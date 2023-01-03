provider "aws" {
  # CloudFront expects ACM resources in us-east-1 region only
  region = "us-east-1"
}

locals {
  name = "ex-${basename(path.cwd)}"

  tags = {
    Name       = local.name
    Example    = "complete"
    Repository = "github.com/terraform-aws-modules/terraform-aws-cloudfront"
  }
}

################################################################################
# Cloudfront Module
################################################################################

module "cloudfront" {
  source = "../../"

  aliases = ["${var.subdomain}.${var.domain_name}"]

  comment         = "My awesome CloudFront"
  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_All"
  http_version    = "http3"

  default_root_object = "index.html"

  # When you enable additional metrics for a distribution, CloudFront sends up to 8 metrics to CloudWatch in the US East (N. Virginia) Region.
  # This rate is charged only once per month, per metric (up to 8 metrics per distribution).
  create_monitoring_subscription = true

  create_origin_access_identity = true
  origin_access_identities = {
    website_s3_bucket = "My awesome CloudFront can access"
  }

  logging_config = {
    bucket = module.log_bucket.s3_bucket_bucket_domain_name
    prefix = "cloudfront"
  }

  origin = {
    website_s3_bucket = {
      domain_name = module.website_s3_bucket.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity_key = "website_s3_bucket" # key in `origin_access_identities`
        # origin_access_identity = "origin-access-identity/cloudfront/E5IGQAA1QO48Z" # external OAI resource
      }
    }

    # appsync = {
    #   domain_name = "appsync.${var.domain_name}"
    #   custom_origin_config = {
    #     http_port              = 80
    #     https_port             = 443
    #     origin_protocol_policy = "match-viewer"
    #     origin_ssl_protocols   = ["TLSv1.2"]
    #   }

    #   custom_header = [
    #     {
    #       name  = "X-Forwarded-Scheme"
    #       value = "https"
    #     },
    #     {
    #       name  = "X-Frame-Options"
    #       value = "SAMEORIGIN"
    #     }
    #   ]

    #   origin_shield = {
    #     enabled              = true
    #     origin_shield_region = "us-east-1"
    #   }
    # }
  }

  # origin_group = {
  #   one = {
  #     failover_status_codes = [403, 404, 500, 502]
  #     members               = ["website_s3_bucket", "appsync"]
  #   }
  # }

  default_cache_behavior = {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true

    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers.id

    forwarded_values = {
      query_string = false

      cookies = {
        forward = "none"
      }
    }

    lambda_function_association = {
      # Valid keys: viewer-request, origin-request, viewer-response, origin-response
      viewer-request = {
        lambda_arn   = module.lambda_function.lambda_function_qualified_arn
        include_body = true
      }

      origin-request = {
        lambda_arn = module.lambda_function.lambda_function_qualified_arn
      }
    }

    target_origin_id       = "website_s3_bucket"
    viewer_protocol_policy = "allow-all"
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "*"
      target_origin_id       = "website_s3_bucket"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true

      response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers.id

      forwarded_values = {
        query_string = false

        cookies = {
          forward = "none"
        }
      }

      function_association = {
        # Valid keys: viewer-request, viewer-response
        viewer-request = {
          function_arn = aws_cloudfront_function.viewer_request.arn
        }

        viewer-response = {
          function_arn = aws_cloudfront_function.viewer_response.arn
        }
      }
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  custom_error_response = [
    {
      error_code         = 404
      response_page_path = "/error.html"
    },
    {
      error_code         = 403
      response_page_path = "/error.html"
    }
  ]

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["NO", "UA", "US", "GB"]
  }

  # Route53 `A`/`AAAA` records
  create_route53_record = true
  route53_zone_id       = data.aws_route53_zone.this.zone_id
  route53_domain_name   = "${var.subdomain}.${var.domain_name}"

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

resource "random_pet" "this" {
  length = 2
}

data "aws_cloudfront_response_headers_policy" "security_headers" {
  name = "Managed-SecurityHeadersPolicy"
}

resource "aws_cloudfront_function" "viewer_response" {
  name    = "viewer-response-${random_pet.this.id}"
  runtime = "cloudfront-js-1.0"
  code    = file("assets/viewer-response.js")
}

resource "aws_cloudfront_function" "viewer_request" {
  name    = "viewer-request-${random_pet.this.id}"
  runtime = "cloudfront-js-1.0"
  code    = file("assets/viewer-request.js")
}

data "aws_route53_zone" "this" {
  name = var.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name               = var.domain_name
  zone_id                   = data.aws_route53_zone.this.id
  subject_alternative_names = ["${var.subdomain}.${var.domain_name}"]

  tags = local.tags
}

data "aws_iam_policy_document" "website_s3_bucket" {
  statement {
    sid = "CloudFrontOAI"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      module.website_s3_bucket.s3_bucket_arn,
      "${module.website_s3_bucket.s3_bucket_arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = [for oai in module.cloudfront.origin_access_identities : oai.iam_arn]
    }
  }
}

module "website_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket        = "website-${random_pet.this.id}"
  force_destroy = true # For example only, not recommended for production

  attach_policy = true
  policy        = data.aws_iam_policy_document.website_s3_bucket.json

  attach_deny_insecure_transport_policy = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags
}

resource "aws_s3_object" "this" {
  for_each = toset(["index.html", "error.html"])

  bucket       = module.website_s3_bucket.s3_bucket_id
  key          = each.value
  source       = "assets/${each.value}"
  content_type = "text/html"

  server_side_encryption = "AES256"

  etag = filemd5("assets/${each.value}")
}

data "aws_canonical_user_id" "current" {}
data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}

module "log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket        = "logs-${random_pet.this.id}"
  force_destroy = true # For example only, not recommended for production

  grant = [
    {
      type       = "CanonicalUser"
      permission = "FULL_CONTROL"
      id         = data.aws_canonical_user_id.current.id
    },
    {
      type       = "CanonicalUser"
      permission = "FULL_CONTROL"
      id         = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
      # Ref. https://github.com/terraform-providers/terraform-provider-aws/issues/12512
      # Ref. https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
    }
  ]

  attach_deny_insecure_transport_policy = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags
}

#############################################
# Lambda@Edge
#############################################

locals {
  package_url = "https://raw.githubusercontent.com/terraform-aws-modules/terraform-aws-lambda/master/examples/fixtures/python3.8-zip/existing_package.zip"
  downloaded  = "downloaded_package_${md5(local.package_url)}.zip"
}

resource "null_resource" "download_package" {
  triggers = {
    downloaded = local.downloaded
  }

  provisioner "local-exec" {
    command = "curl -L -o ${local.downloaded} ${local.package_url}"
  }
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = "${random_pet.this.id}-lambda"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  publish        = true
  lambda_at_edge = true

  create_package         = false
  local_existing_package = local.downloaded

  tags = local.tags
}
