# terraform-ovh
Terraform modules for OVH


## Module DNS zone

Create a custom DNS zone

```
module "service_zone" {
  source = "git@github.com:LeastAuthority/terraform-ovh.git//domain_zone?ref=1.0.2"
  name   = "foobar.xyz"
}
```

## Module DNS records 

Create a number of DNS A/AAAA records for a given list of ip addresses.

Can add entries for IPv4 and IPv6 addresses and has support for multiple targets and additional CNAME records.

```
module "foo-service-dns" {
  source = "git@github.com:LeastAuthority/terraform-ovh.git//dns_records?ref=1.0.2"

  target_zone  = module.service_zone.name
  ips          = data.ovh_vps.foo-service.ips
  target_names = ["api", "auth"]
  cname_zones  = [module.main_zone.name]
  disable_ipv6 = true
}
```