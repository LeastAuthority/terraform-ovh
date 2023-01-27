variable "name" {
  type = string
}

variable "ovh_subsidiary" {
  default       = "fr"
  description   = "OVH subsidiary. Defaults to 'ca'. Allowed is 'fr', 'ca'."
  condition     = contains(["fr", "ca"], var.ovh_subsidiary)
  error_message = "ovh_subsidiary must be 'fr' or 'ca'."
}