terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
    }
  }
}

data "ovh_order_cart" "default" {
  ovh_subsidiary = "ca"
}

data "ovh_order_cart_product_plan" "zone" {
  cart_id        = data.ovh_order_cart.default.id
  price_capacity = "renew"
  product        = "dns"
  plan_code      = "zone"
}

resource "ovh_domain_zone" "default" {
  ovh_subsidiary = data.ovh_order_cart.default.ovh_subsidiary
  payment_mean   = "fidelity"

  plan {
    duration     = data.ovh_order_cart_product_plan.zone.selected_price.0.duration
    plan_code    = data.ovh_order_cart_product_plan.zone.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.zone.selected_price.0.pricing_mode

    configuration {
      label = "zone"
      value = var.name
    }

    configuration {
      label = "template"
      value = "minimized"
    }
  }
}
