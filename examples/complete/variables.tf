variable "domain_name" {
  description = "The domain name for the distribution"
  type        = string
  # default     = "terraform-aws-modules.modules.tf"
  default = "sharedservices.clowd.haus"
}

variable "subdomain" {
  description = "The subdomain for the distribution"
  type        = string
  default     = "cdn"
}
