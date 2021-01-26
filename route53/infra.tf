resource "aws_route53_record" "record" {
  zone_id = var.aws_zone
  name    = var.domain
  type    = "A"
  ttl     = "300"
  records = [var.address]
}