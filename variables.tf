variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Distribution
################################################################################

variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution"
  type        = list(string)
  default     = null
}

variable "cd_policy_id" {
  description = "Identifier of a continuous deployment policy when `create_cd_policy = false`. This argument should only be set on a production distribution"
  type        = string
  default     = null
}

variable "comment" {
  description = "Any comments you want to include about the distribution"
  type        = string
  default     = null
}

variable "custom_error_response" {
  description = "One or more custom error response elements"
  type        = any
  default     = {}
}

variable "default_cache_behavior" {
  description = "The default cache behavior for this distribution"
  type        = any
  default     = {}
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL"
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content"
  type        = bool
  default     = true
}

variable "http_version" {
  description = "The maximum HTTP version to support on the distribution. Allowed values are `http2` and `http3`. The default is `http2`"
  type        = string
  default     = null
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution"
  type        = bool
  default     = null
}

variable "logging_config" {
  description = "The logging configuration that controls how logs are written to your distribution (maximum one)"
  type        = any
  default     = {}
}

variable "ordered_cache_behavior" {
  description = "An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0"
  type        = any
  default     = []
}

variable "origin_group" {
  description = "One or more origin_group for this distribution (multiples allowed)"
  type        = any
  default     = {}
}

variable "origin" {
  description = "One or more origins for this distribution (multiples allowed)"
  type        = any
  default     = {}
}

variable "price_class" {
  description = "The price class for this distribution. One of `PriceClass_All`, `PriceClass_200`, `PriceClass_100`"
  type        = string
  default     = null
}

variable "geo_restriction" {
  description = "The restriction configuration for this distribution (geo_restrictions)"
  type        = any
  default     = {}
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards"
  type        = bool
  default     = false
}

variable "staging" {
  description = "A Boolean that indicates whether this is a staging distribution. Defaults to `false`"
  type        = bool
  default     = null
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type        = any
  default = {
    cloudfront_default_certificate = true
  }
}

variable "web_acl_id" {
  description = "If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL"
  type        = string
  default     = null
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from `InProgress` to `Deployed`. Setting this to false will skip the process"
  type        = bool
  default     = true
}

################################################################################
# Continous Deployment Policy
################################################################################

variable "create_cd_policy" {
  description = "Controls if CloudFront continuous deployment policy should be created"
  type        = bool
  default     = false
}

variable "cd_policy_enabled" {
  description = "Whether the policy is enabled"
  type        = bool
  default     = true
}

variable "cd_policy_staging_distribution_dns_names" {
  description = "The DNS names of the staging distribution"
  type        = any
  default     = {}
}

variable "cd_policy_traffic_config" {
  description = "Parameters for routing production traffic from primary to staging distributions"
  type        = any
  default     = {}
}

################################################################################
# Origin Access Identity
################################################################################

variable "create_origin_access_identity" {
  description = "Controls if CloudFront origin access identity should be created"
  type        = bool
  default     = false
}

variable "origin_access_identities" {
  description = "Map of CloudFront origin access identities (value as a comment)"
  type        = map(string)
  default     = {}
}

################################################################################
# Origin Access Control
################################################################################

variable "create_origin_access_control" {
  description = "Controls if CloudFront origin access control(s) should be created"
  type        = bool
  default     = false
}

variable "origin_access_controls" {
  description = "Map of CloudFront origin access controls to create"
  type        = map(string)
  default     = {}
}

################################################################################
# Monitoring Subscription
################################################################################

variable "create_monitoring_subscription" {
  description = "If enabled, the resource for monitoring subscription will created"
  type        = bool
  default     = false
}

variable "realtime_metrics_subscription_status" {
  description = "A flag that indicates whether additional CloudWatch metrics are enabled for a given CloudFront distribution. Valid values are `Enabled` and `Disabled`"
  type        = string
  default     = "Enabled"
}

################################################################################
# Route53 Record
################################################################################

variable "create_route53_record" {
  description = "Controls if Route53 `A` and `AAAA` records should be created"
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "The ID of the Route53 zone where the records will be created"
  type        = string
  default     = null
}

variable "route53_domain_name" {
  description = "The name of the domain the Route53 records will point to"
  type        = string
  default     = null
}
