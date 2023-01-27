terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
    }
  }
}

locals {
  backend_ipv4 = toset([for ip in var.ips : ip if !can(regex("::", ip))])
  backend_ipv6 = toset([for ip in var.ips : ip if can(regex("::", ip))])
  backend_records = concat(
    [for ip in local.backend_ipv4 : { record_type = "A", ip = ip }],
    var.disable_ipv6 ? [] : [for ip in local.backend_ipv6 : { record_type = "AAAA", ip = ip }]
  )
}

resource "ovh_domain_zone_record" "backend" {
  for_each = {
    for val in setproduct(var.target_names, [
      var.target_zone
      ], local.backend_records) : "${val[0]}.${val[1]}-${val[2].record_type}-${val[2].ip}" => merge(val[2], {
      target_name = val[0]
      target_zone = val[1]
    })
  }
  zone      = lookup(each.value, "target_zone")
  subdomain = lookup(each.value, "target_name")
  fieldtype = lookup(each.value, "record_type")
  ttl       = var.ttl
  target    = lookup(each.value, "ip")
}

resource "ovh_domain_zone_record" "backend_cname" {
  for_each = {
    for val in setproduct(var.target_names, var.cname_zones) : "${val[0]}.${val[1]}" => {
      target_name = val[0]
      target_zone = val[1]
    }
  }
  zone      = lookup(each.value, "target_zone")
  subdomain = lookup(each.value, "target_name")
  fieldtype = "CNAME"
  ttl       = var.ttl
  target    = "${lookup(each.value, "target_name")}.${var.target_zone}."
}
