resource "aws_route53_zone" "primary_zone" {
  count = var.create_dns_zone ? 1 : 0
  name = var.domain
}

data "aws_route53_zone" "primary_zone" {
  count = var.create_dns_zone ? 1 : 0
  name = var.domain
}

locals {
  dns_zone_id = var.create_dns_zone ? aws_route53_zone.primary_zone[0].zone_id : data.aws_route53_zone.primary_zone[0].zone_id
  subdomain = var.environment_name == "production" ? "" : "${var.environment_name}."
}

resource "aws_route53_record" "route_record" {
  zone_id = local.dns_zone_id
  name = "${local.subdomain}${var.domain}"
  type = "A"

  alias {
    name = aws_lb.load_balancer.dns_name
    zone_id = aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  }
}