resource "aws_acm_certificate" "acm_cert" {
  domain_name       = "tm.shabnamkhan.tech"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


# Route53
# resource "aws_route53_zone" "primary" {
#   name = "example.com"
# }