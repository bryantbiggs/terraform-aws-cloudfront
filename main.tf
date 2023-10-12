################################################################################
# Distribution
################################################################################

resource "aws_cloudfront_distribution" "this" {
  count = var.create ? 1 : 0

  aliases                         = var.aliases
  continuous_deployment_policy_id = var.create_cd_policy ? aws_cloudfront_continuous_deployment_policy.this[0].id : var.cd_policy_id
  comment                         = var.comment

  dynamic "custom_error_response" {
    for_each = var.custom_error_response

    content {
      error_caching_min_ttl = try(custom_error_response.value.error_caching_min_ttl, null)
      error_code            = custom_error_response.value.error_code
      response_code         = try(custom_error_response.value.response_code, custom_error_response.value.error_code, null)
      response_page_path    = try(custom_error_response.value.response_page_path, null)
    }
  }

  dynamic "default_cache_behavior" {
    for_each = length(var.default_cache_behavior) > 1 ? [var.default_cache_behavior] : []

    content {
      allowed_methods           = try(default_cache_behavior.value.allowed_methods, ["GET", "HEAD", "OPTIONS"])
      cached_methods            = try(default_cache_behavior.value.cached_methods, ["GET", "HEAD"])
      cache_policy_id           = lookup(default_cache_behavior.value, "cache_policy_id", null)
      compress                  = try(default_cache_behavior.value.compress, null)
      default_ttl               = try(default_cache_behavior.value.default_ttl, null)
      field_level_encryption_id = lookup(default_cache_behavior.value, "field_level_encryption_id", null)

      dynamic "forwarded_values" {
        for_each = try([default_cache_behavior.value.forwarded_values], [])

        content {
          cookies {
            forward           = try(forwarded_values.value.cookies_forward, "none")
            whitelisted_names = try(forwarded_values.value.cookies_whitelisted_names, null)
          }

          headers                 = try(forwarded_values.value.headers, [])
          query_string            = try(forwarded_values.value.query_string, false)
          query_string_cache_keys = try(forwarded_values.value.query_string_cache_keys, [])
        }
      }

      dynamic "lambda_function_association" {
        for_each = try(default_cache_behavior.value.lambda_function_association, [])

        content {
          event_type   = try(lambda_function_association.value.event_type, lambda_function_association.key)
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = try(lambda_function_association.value.include_body, null)
        }
      }

      dynamic "function_association" {
        for_each = try(default_cache_behavior.value.function_association, [])

        content {
          event_type   = try(function_association.value.event_type, function_association.key)
          function_arn = function_association.value.function_arn
        }
      }

      max_ttl                    = try(default_cache_behavior.value.max_ttl, null)
      min_ttl                    = try(default_cache_behavior.value.min_ttl, null)
      origin_request_policy_id   = try(default_cache_behavior.value.origin_request_policy_id, null)
      realtime_log_config_arn    = try(default_cache_behavior.value.realtime_log_config_arn, null)
      response_headers_policy_id = try(default_cache_behavior.value.response_headers_policy_id, null)
      smooth_streaming           = try(default_cache_behavior.value.smooth_streaming, null)
      target_origin_id           = default_cache_behavior.value.target_origin_id
      trusted_key_groups         = try(default_cache_behavior.value.trusted_key_groups, null)
      trusted_signers            = try(default_cache_behavior.value.trusted_signers, null)
      viewer_protocol_policy     = default_cache_behavior.value.viewer_protocol_policy
    }
  }

  default_root_object = var.default_root_object
  enabled             = var.enabled
  http_version        = var.http_version
  is_ipv6_enabled     = var.is_ipv6_enabled

  dynamic "logging_config" {
    for_each = length(var.logging_config) > 0 ? [var.logging_config] : []

    content {
      bucket          = logging_config.value.bucket
      include_cookies = try(logging_config.value.include_cookies, null)
      prefix          = try(logging_config.value.prefix, null)
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior

    content {
      allowed_methods           = try(ordered_cache_behavior.value.allowed_methods, ["GET", "HEAD", "OPTIONS"])
      cached_methods            = try(ordered_cache_behavior.value.cached_methods, ["GET", "HEAD"])
      cache_policy_id           = lookup(ordered_cache_behavior.value, "cache_policy_id", null)
      compress                  = try(ordered_cache_behavior.value.compress, null)
      default_ttl               = try(ordered_cache_behavior.value.default_ttl, null)
      field_level_encryption_id = lookup(ordered_cache_behavior.value, "field_level_encryption_id", null)

      dynamic "forwarded_values" {
        for_each = try([ordered_cache_behavior.value.forwarded_values], [])

        content {
          cookies {
            forward           = try(forwarded_values.value.cookies_forward, "none")
            whitelisted_names = try(forwarded_values.value.cookies_whitelisted_names, null)
          }

          headers                 = try(forwarded_values.value.headers, null)
          query_string            = try(forwarded_values.value.query_string, false)
          query_string_cache_keys = try(forwarded_values.value.query_string_cache_keys, null)
        }
      }

      dynamic "lambda_function_association" {
        for_each = try(ordered_cache_behavior.value.lambda_function_association, [])

        content {
          event_type   = try(lambda_function_association.value.event_type, lambda_function_association.key)
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = try(lambda_function_association.value.include_body, null)
        }
      }

      dynamic "function_association" {
        for_each = try(ordered_cache_behavior.value.function_association, [])

        content {
          event_type   = try(function_association.value.event_type, function_association.key)
          function_arn = function_association.value.function_arn
        }
      }

      min_ttl                    = try(ordered_cache_behavior.value.min_ttl, null)
      max_ttl                    = try(ordered_cache_behavior.value.max_ttl, null)
      origin_request_policy_id   = try(ordered_cache_behavior.value.origin_request_policy_id, null)
      path_pattern               = ordered_cache_behavior.value.path_pattern
      realtime_log_config_arn    = try(ordered_cache_behavior.value.realtime_log_config_arn, null)
      response_headers_policy_id = try(ordered_cache_behavior.value.response_headers_policy_id, null)
      smooth_streaming           = try(ordered_cache_behavior.value.smooth_streaming, null)
      target_origin_id           = ordered_cache_behavior.value.target_origin_id
      trusted_key_groups         = try(ordered_cache_behavior.value.trusted_key_groups, null)
      trusted_signers            = try(ordered_cache_behavior.value.trusted_signers, null)
      viewer_protocol_policy     = ordered_cache_behavior.value.viewer_protocol_policy
    }
  }

  dynamic "origin_group" {
    for_each = var.origin_group

    content {
      origin_id = lookup(origin_group.value, "origin_id", origin_group.key)

      failover_criteria {
        status_codes = origin_group.value.failover_status_codes
      }

      dynamic "member" {
        for_each = try(origin_group.value.members, [])

        content {
          origin_id = member.value
        }
      }
    }
  }

  dynamic "origin" {
    for_each = var.origin

    content {
      connection_attempts = try(origin.value.connection_attempts, null)
      connection_timeout  = try(origin.value.connection_timeout, null)

      dynamic "custom_origin_config" {
        for_each = try([origin.value.custom_origin_config], [])

        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_keepalive_timeout = try(custom_origin_config.value.origin_keepalive_timeout, null)
          origin_read_timeout      = try(custom_origin_config.value.origin_read_timeout, null)
          origin_protocol_policy   = try(custom_origin_config.value.origin_protocol_policy, "https-only")
          origin_ssl_protocols     = try(custom_origin_config.value.origin_ssl_protocols, "TLSv1.2")
        }
      }

      domain_name = origin.value.domain_name

      dynamic "custom_header" {
        for_each = try(origin.value.custom_header, [])

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      origin_access_control_id = try(origin.value.origin_access_control_id, aws_cloudfront_origin_access_control.this[origin.value.origin_access_control_key].id, null)
      origin_id                = try(origin.value.origin_id, origin.key)
      origin_path              = try(origin.value.origin_path, null)

      dynamic "origin_shield" {
        for_each = try([origin.value.origin_shield], [])

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = try(origin_shield.value.origin_shield_region, null)
        }
      }

      dynamic "s3_origin_config" {
        for_each = try([origin.value.s3_origin_config], [])

        content {
          origin_access_identity = try(s3_origin_config.value.origin_access_identity, aws_cloudfront_origin_access_identity.this[s3_origin_config.value.origin_access_identity_key].cloudfront_access_identity_path, null)
        }
      }
    }
  }

  price_class = var.price_class

  restrictions {
    dynamic "geo_restriction" {
      for_each = [var.geo_restriction]

      content {
        locations        = try(geo_restriction.value.locations, [])
        restriction_type = try(geo_restriction.value.restriction_type, "none")
      }
    }
  }

  retain_on_delete = var.retain_on_delete
  staging          = var.staging

  viewer_certificate {
    acm_certificate_arn            = lookup(var.viewer_certificate, "acm_certificate_arn", null)
    cloudfront_default_certificate = lookup(var.viewer_certificate, "cloudfront_default_certificate", null)
    iam_certificate_id             = lookup(var.viewer_certificate, "iam_certificate_id", null)
    minimum_protocol_version       = try(var.viewer_certificate.minimum_protocol_version, "TLSv1.2_2021")
    ssl_support_method             = try(var.viewer_certificate.ssl_support_method, null)
  }

  web_acl_id          = var.web_acl_id
  wait_for_deployment = var.wait_for_deployment
  tags                = var.tags
}

################################################################################
# Continous Deployment Policy
################################################################################

resource "aws_cloudfront_continuous_deployment_policy" "this" {
  count = var.create && var.create_cd_policy ? 1 : 0

  enabled = var.cd_policy_enabled

  dynamic "staging_distribution_dns_names" {
    for_each = [var.cd_policy_staging_distribution_dns_names]

    content {
      items    = staging_distribution_dns_names.value.items
      quantity = staging_distribution_dns_names.value.quantity
    }
  }

  dynamic "traffic_config" {
    for_each = [var.cd_policy_traffic_config]

    content {
      type = traffic_config.value.type

      dynamic "single_header_config" {
        for_each = try([traffic_config.value.single_header_config], [])

        content {
          header = single_header_config.value.header
          value  = single_header_config.value.value
        }
      }

      dynamic "single_weight_config" {
        for_each = try([traffic_config.value.single_weight_config], [])

        content {
          weight = single_weight_config.value.weight

          dynamic "session_stickiness_config" {
            for_each = try([traffic_config.value.session_stickiness_config], [])

            content {
              idle_ttl    = session_stickiness_config.value.idle_ttl
              maximum_ttl = session_stickiness_config.value.maximum_ttl
            }
          }
        }
      }
    }
  }
}

################################################################################
# Origin Access Identity
################################################################################

resource "aws_cloudfront_origin_access_identity" "this" {
  for_each = { for k, v in var.origin_access_identities : k => v if var.create && var.create_origin_access_identity }

  comment = each.value

  lifecycle {
    create_before_destroy = true
  }
}

################################################################################
# Origin Access Control
################################################################################

resource "aws_cloudfront_origin_access_control" "this" {
  for_each = { for k, v in var.origin_access_controls : k => v if var.create && var.create_origin_access_control }

  description                       = try(each.value.description, null)
  name                              = try(each.value.name, each.key)
  origin_access_control_origin_type = try(each.value.origin_type, "s3")
  signing_behavior                  = try(each.value.signing_behavior, "always")
  signing_protocol                  = try(each.value.signing_protocol, "sigv4")
}

################################################################################
# Monitoring Subscription
################################################################################

resource "aws_cloudfront_monitoring_subscription" "this" {
  count = var.create && var.create_monitoring_subscription ? 1 : 0

  distribution_id = aws_cloudfront_distribution.this[0].id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = var.realtime_metrics_subscription_status
    }
  }
}

################################################################################
# Route53 Record
################################################################################

resource "aws_route53_record" "this" {
  for_each = { for k, v in toset(["A", "AAAA"]) : k => v if var.create && var.create_route53_record }

  zone_id = var.route53_zone_id
  name    = var.route53_domain_name
  type    = each.value

  alias {
    name                   = aws_cloudfront_distribution.this[0].domain_name
    zone_id                = aws_cloudfront_distribution.this[0].hosted_zone_id
    evaluate_target_health = true
  }
}
