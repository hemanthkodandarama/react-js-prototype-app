data "aws_route53_zone" "selected" {
  count        = "${var.route53_hosted_zone_id=="" ? 0 : 1}"
  zone_id      = "${var.route53_hosted_zone_id}"
  private_zone = true
}

locals {
  default_hostname   = "demo-${var.swimlane}"
  route53_domain_raw = "${join("", data.aws_route53_zone.selected.*.name)}"
  route53_domain     = "${substr(local.route53_domain_raw, 0, length(local.route53_domain_raw) - 1)}"
  fqdn               = "${var.route53_hosted_zone_id=="" ? var.domain_name : "${local.default_hostname}.${local.route53_domain}"}"
  ws_fqdn            = "${"${element(local.domain_list, 0)}-ws.${join(".", slice(local.domain_list, 1, length(local.domain_list)))}"}"
  domain_list        = "${split(".", local.fqdn)}"
}

resource "aws_route53_record" "dns-demo" {
  count   = "${var.route53_hosted_zone_id=="" ? 0 : 1}"
  zone_id = "${var.route53_hosted_zone_id}"
  name    = "${local.default_hostname}"
  type    = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.api-domain.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.api-domain.regional_zone_id}"
    evaluate_target_health = false
  }
}
