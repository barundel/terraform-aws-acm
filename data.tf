data "aws_route53_zone" "zones" {
  count    = "${length(local.domain_lookup_list) > 0 ? length(local.domain_lookup_list) : 0}"

  name = "${element(local.domain_lookup_list, count.index)}"
}
