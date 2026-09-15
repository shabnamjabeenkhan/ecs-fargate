resource "aws_acm_certificate" "acm_cert" {
  domain_name       = "tm.shabnamkhan.tech"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


# Route53
resource "aws_route53_zone" "threatmod_route53" {
  name = "shabnamkhan.tech"
}

# alis record pointing to subdomain
resource "aws_route53_record" "tm_subdomain" {
  zone_id = aws_route53_zone.threatmod_route53.zone_id
  name    = "tm.shabnamkhan.tech"
  type    = "A"

  alias {
    name                   = aws_lb.ecs_alb.dns_name
    zone_id                = aws_lb.ecs_alb.zone_id
    evaluate_target_health = true
  }
}


# ACM VAlidation
resource "aws_route53_record" "acm_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.threatmod_route53.zone_id
}

resource "aws_acm_certificate_validation" "acm_validation" {
  certificate_arn         = aws_acm_certificate.acm_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation_record : record.fqdn]
}