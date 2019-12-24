resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = var.validation_method

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_acm_certificate_validation" "domain_validation" {
  count           = "${var.validation_method == "DNS" ? 1 : 0}"
  certificate_arn = aws_acm_certificate.cert.arn

  validation_record_fqdns = [
    aws_route53_record.cert_validation.*.fqdn
  ]
}


resource "aws_route53_record" "cert_validation" {
  count    = "${var.validation_method == "DNS" && length(local.domain_lookup_list) > 0 ? length(local.domain_lookup_list) : 0}"

  allow_overwrite = "${var.allow_overwrite_validation}"

  name    = "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_type")}"
  records = ["${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_value")}"]

  zone_id = "${lookup(zipmap(local.ssl_name_list, data.aws_route53_zone.zones.*.id), lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "domain_name"))}"
  ttl     = "300"
}

locals {
  domain_lookup_list = "${sort(concat(var.alt_domain_lookup, list(var.domain_name_lookup)))}"
  ssl_name_list      = "${sort(concat(var.subject_alternative_names, list(var.domain_name)))}"
}
