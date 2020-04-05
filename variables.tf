locals {
  distinct_domain_names = distinct(concat([var.domain_name], [for s in var.subject_alternative_names : replace(s, "*.", "")]))
  validation_domains = [for k, v in aws_acm_certificate.this.domain_validation_options : tomap(v) if contains(local.distinct_domain_names, v.domain_name)]
}

variable "domain_name" {
  description = "A domain name for which the certificate should be issued"
  type        = string
  default     = ""
}

variable "subject_alternative_names" {
  description = "A list of domains that should be SANs in the issued certificate"
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "Which method to use for validation. DNS or EMAIL are valid, NONE can be used for certificates that were imported into ACM and then into Terraform."
  type        = string
  default     = "DNS"
}

variable "zone_id" {
  description = "The ID of the hosted zone to contain this record."
  type        = string
  default     = ""
}

variable "ttl" {
  description = "The TTL of the record."
  type        = number
  default     = 60
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "validate_certificate" {
  description = "Whether or not certificate should be validated"
  type        = bool
  default     = true
}

variable "allow_overwrite_records" {
  description = "Allow creation of this record in Terraform to overwrite an existing record, if any."
  type        = bool
  default     = true
}