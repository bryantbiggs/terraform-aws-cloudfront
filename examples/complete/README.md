# Complete CloudFront distribution with most of supported features enabled

Configuration in this directory creates CloudFront distribution which demos such capabilities:
- access logging
- origins and origin groups
- caching behaviours
- Origin Access Identities (with S3 bucket policy)
- Lambda@Edge
- ACM certificate
- Route53 record

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.29 |
| <a name="requirement_external"></a> [external](#requirement\_external) | >= 1.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.29 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 4.0 |
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | ../../ | n/a |
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 4.0 |
| <a name="module_log_bucket"></a> [log\_bucket](#module\_log\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.0 |
| <a name="module_website_s3_bucket"></a> [website\_s3\_bucket](#module\_website\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_function.viewer_request](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |
| [aws_cloudfront_function.viewer_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |
| [aws_s3_object.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [null_resource.download_package](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |
| [aws_cloudfront_log_delivery_canonical_user_id.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_log_delivery_canonical_user_id) | data source |
| [aws_cloudfront_response_headers_policy.security_headers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_response_headers_policy) | data source |
| [aws_iam_policy_document.website_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name for the distribution | `string` | `"sharedservices.clowd.haus"` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | The subdomain for the distribution | `string` | `"cdn"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_distribution_arn"></a> [distribution\_arn](#output\_distribution\_arn) | The ARN (Amazon Resource Name) for the distribution |
| <a name="output_distribution_caller_reference"></a> [distribution\_caller\_reference](#output\_distribution\_caller\_reference) | Internal value used by CloudFront to allow future updates to the distribution configuration |
| <a name="output_distribution_domain_name"></a> [distribution\_domain\_name](#output\_distribution\_domain\_name) | The domain name corresponding to the distribution |
| <a name="output_distribution_etag"></a> [distribution\_etag](#output\_distribution\_etag) | The current version of the distribution's information |
| <a name="output_distribution_hosted_zone_id"></a> [distribution\_hosted\_zone\_id](#output\_distribution\_hosted\_zone\_id) | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to |
| <a name="output_distribution_id"></a> [distribution\_id](#output\_distribution\_id) | The identifier for the distribution |
| <a name="output_distribution_in_progress_validation_batches"></a> [distribution\_in\_progress\_validation\_batches](#output\_distribution\_in\_progress\_validation\_batches) | The number of invalidation batches currently in progress |
| <a name="output_distribution_last_modified_time"></a> [distribution\_last\_modified\_time](#output\_distribution\_last\_modified\_time) | The date and time the distribution was last modified |
| <a name="output_distribution_status"></a> [distribution\_status](#output\_distribution\_status) | The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system |
| <a name="output_distribution_trusted_key_groups"></a> [distribution\_trusted\_key\_groups](#output\_distribution\_trusted\_key\_groups) | List of nested attributes for active trusted key groups, if the distribution is set up to serve private content with signed URLs |
| <a name="output_distribution_trusted_signers"></a> [distribution\_trusted\_signers](#output\_distribution\_trusted\_signers) | List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs |
| <a name="output_monitoring_subscription_id"></a> [monitoring\_subscription\_id](#output\_monitoring\_subscription\_id) | The ID of the CloudFront monitoring subscription |
| <a name="output_origin_access_controls"></a> [origin\_access\_controls](#output\_origin\_access\_controls) | The origin access controls created |
| <a name="output_origin_access_identities"></a> [origin\_access\_identities](#output\_origin\_access\_identities) | The origin access identities created |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
