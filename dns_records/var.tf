variable "ips" {
  default = []
  type    = list(string)
}

variable "target_names" {
  default = [""]
}

variable "target_zone" {
  type = string
}

variable "cname_zones" {
  default = []
  type    = list(string)
}

variable "disable_ipv6" {
  default = false
}

variable "ttl" {
  default = 3600
}