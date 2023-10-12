################################################################################
# Distribution
################################################################################

output "distribution_id" {
  description = "The identifier for the distribution"
  value       = try(aws_cloudfront_distribution.this[0].id, null)
}

output "distribution_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution"
  value       = try(aws_cloudfront_distribution.this[0].arn, null)
}

output "distribution_caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration"
  value       = try(aws_cloudfront_distribution.this[0].caller_reference, null)
}

output "distribution_status" {
  description = "The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system"
  value       = try(aws_cloudfront_distribution.this[0].status, null)
}

output "distribution_trusted_key_groups" {
  description = "List of nested attributes for active trusted key groups, if the distribution is set up to serve private content with signed URLs"
  value       = try(aws_cloudfront_distribution.this[0].trusted_signers, null)
}

output "distribution_trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = try(aws_cloudfront_distribution.this[0].trusted_signers, null)
}

output "distribution_domain_name" {
  description = "The domain name corresponding to the distribution"
  value       = try(aws_cloudfront_distribution.this[0].domain_name, null)
}

output "distribution_last_modified_time" {
  description = "The date and time the distribution was last modified"
  value       = try(aws_cloudfront_distribution.this[0].last_modified_time, null)
}

output "distribution_in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress"
  value       = try(aws_cloudfront_distribution.this[0].in_progress_validation_batches, null)
}

output "distribution_etag" {
  description = "The current version of the distribution's information"
  value       = try(aws_cloudfront_distribution.this[0].etag, null)
}

output "distribution_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to"
  value       = try(aws_cloudfront_distribution.this[0].hosted_zone_id, null)
}

################################################################################
# Continous Deployment Policy
################################################################################

output "cd_policy_etag" {
  description = "Current version of the continuous distribution policy"
  value       = try(aws_cloudfront_continuous_deployment_policy.this[0].etag, null)
}

output "cd_policy_id" {
  description = "Identifier of the continuous deployment policy"
  value       = try(aws_cloudfront_continuous_deployment_policy.this[0].id, null)
}

################################################################################
# Origin Access Identity
################################################################################

output "origin_access_identities" {
  description = "The origin access identities created"
  value       = aws_cloudfront_origin_access_identity.this
}

################################################################################
# Origin Access Control
################################################################################

output "origin_access_controls" {
  description = "The origin access controls created"
  value       = aws_cloudfront_origin_access_control.this
}

################################################################################
# Monitoring Subscription
################################################################################

output "monitoring_subscription_id" {
  description = " The ID of the CloudFront monitoring subscription"
  value       = try(aws_cloudfront_monitoring_subscription.this[0].id, null)
}

################################################################################
# Route53 Record
################################################################################

output "route53_records" {
  description = "The Route53 records created"
  value       = aws_route53_record.this
}
