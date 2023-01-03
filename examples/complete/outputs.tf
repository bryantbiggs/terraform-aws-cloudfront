################################################################################
# Distribution
################################################################################

output "distribution_id" {
  description = "The identifier for the distribution"
  value       = module.cloudfront.distribution_id
}

output "distribution_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution"
  value       = module.cloudfront.distribution_arn
}

output "distribution_caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration"
  value       = module.cloudfront.distribution_caller_reference
}

output "distribution_status" {
  description = "The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system"
  value       = module.cloudfront.distribution_status
}

output "distribution_trusted_key_groups" {
  description = "List of nested attributes for active trusted key groups, if the distribution is set up to serve private content with signed URLs"
  value       = module.cloudfront.distribution_trusted_key_groups
}

output "distribution_trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = module.cloudfront.distribution_trusted_signers
}

output "distribution_domain_name" {
  description = "The domain name corresponding to the distribution"
  value       = module.cloudfront.distribution_domain_name
}

output "distribution_last_modified_time" {
  description = "The date and time the distribution was last modified"
  value       = module.cloudfront.distribution_last_modified_time
}

output "distribution_in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress"
  value       = module.cloudfront.distribution_in_progress_validation_batches
}

output "distribution_etag" {
  description = "The current version of the distribution's information"
  value       = module.cloudfront.distribution_etag
}

output "distribution_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to"
  value       = module.cloudfront.distribution_hosted_zone_id
}

################################################################################
# Origin Access Identity
################################################################################

output "origin_access_identities" {
  description = "The origin access identities created"
  value       = module.cloudfront.origin_access_identities
}

################################################################################
# Monitoring Subscription
################################################################################

output "monitoring_subscription_id" {
  description = " The ID of the CloudFront monitoring subscription"
  value       = module.cloudfront.monitoring_subscription_id
}
