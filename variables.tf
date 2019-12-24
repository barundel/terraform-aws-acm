variable "domain_name" {
  description = "(Required) A domain name for which the certificate should be issued"
}

variable "subject_alternative_names" {
  default = ""
  description = "(Optional) A list of domains that should be SANs in the issued certificate"
}

variable "validation_method" {
  default = "DNS"
  description = "Which method to use for validation. DNS or EMAIL are valid"
}

variable "tags" {
  default = {}
  description = "A mapping of tags to assign to the resource."
}

variable "allow_overwrite_validation" {
  description = "Default set to false, alows the overwriting of the validation record in route53 for when verifying the same acm in multiple regions"
  default = false
}

variable "alt_domain_lookup" {
  description = "Alt domain's when using SANS the order needs to match the SANs list"
  default     = []

  type = "list"
}

variable "domain_name_lookup" {
  description = "Zone to Lookup in R53"
}