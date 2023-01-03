module "wrapper" {
  source = "../"

  for_each = var.items

  create                 = try(each.value.create, var.defaults.create, true)
  tags                   = try(each.value.tags, var.defaults.tags, {})
  aliases                = try(each.value.aliases, var.defaults.aliases, null)
  comment                = try(each.value.comment, var.defaults.comment, null)
  custom_error_response  = try(each.value.custom_error_response, var.defaults.custom_error_response, {})
  default_cache_behavior = try(each.value.default_cache_behavior, var.defaults.default_cache_behavior, {})
  default_root_object    = try(each.value.default_root_object, var.defaults.default_root_object, null)
  enabled                = try(each.value.enabled, var.defaults.enabled, true)
  http_version           = try(each.value.http_version, var.defaults.http_version, null)
  is_ipv6_enabled        = try(each.value.is_ipv6_enabled, var.defaults.is_ipv6_enabled, null)
  logging_config         = try(each.value.logging_config, var.defaults.logging_config, {})
  ordered_cache_behavior = try(each.value.ordered_cache_behavior, var.defaults.ordered_cache_behavior, [])
  origin_group           = try(each.value.origin_group, var.defaults.origin_group, {})
  origin                 = try(each.value.origin, var.defaults.origin, {})
  price_class            = try(each.value.price_class, var.defaults.price_class, null)
  geo_restriction        = try(each.value.geo_restriction, var.defaults.geo_restriction, {})
  retain_on_delete       = try(each.value.retain_on_delete, var.defaults.retain_on_delete, false)
  viewer_certificate = try(each.value.viewer_certificate, var.defaults.viewer_certificate, {
    cloudfront_default_certificate = true
  })
  web_acl_id                           = try(each.value.web_acl_id, var.defaults.web_acl_id, null)
  wait_for_deployment                  = try(each.value.wait_for_deployment, var.defaults.wait_for_deployment, true)
  create_origin_access_identity        = try(each.value.create_origin_access_identity, var.defaults.create_origin_access_identity, false)
  origin_access_identities             = try(each.value.origin_access_identities, var.defaults.origin_access_identities, {})
  create_origin_access_control         = try(each.value.create_origin_access_control, var.defaults.create_origin_access_control, false)
  origin_access_controls               = try(each.value.origin_access_controls, var.defaults.origin_access_controls, {})
  create_monitoring_subscription       = try(each.value.create_monitoring_subscription, var.defaults.create_monitoring_subscription, false)
  realtime_metrics_subscription_status = try(each.value.realtime_metrics_subscription_status, var.defaults.realtime_metrics_subscription_status, "Enabled")
  create_route53_record                = try(each.value.create_route53_record, var.defaults.create_route53_record, false)
  route53_zone_id                      = try(each.value.route53_zone_id, var.defaults.route53_zone_id, null)
  route53_domain_name                  = try(each.value.route53_domain_name, var.defaults.route53_domain_name, null)
}
