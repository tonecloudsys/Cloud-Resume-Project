data "aws_route53_zone" "tdh-zone" {
    name = "toneherndon.com"
}
# Creates an ACM Certificate
resource "aws_acm_certificate" "tdh-resume-certificate" {
    domain_name = "resume.toneherndon.com"
    validation_method = "DNS"
    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_route53_record" "tdh-cert-dns" {
allow_overwrite = true
name = tolist(aws_acm_certificate.tdh-resume-certificate.domain_validation_options)[0].resource_record_name
records = [tolist(aws_acm_certificate.tdh-resume-certificate.domain_validation_options)[0].resource_record_value]
type = tolist(aws_acm_certificate.tdh-resume-certificate.domain_validation_options)[0].resource_record_type
zone_id = data.aws_route53_zone.tdh-zone.zone_id
ttl = 60
}

resource "aws_acm_certificate_validation" "tdh-cert-validate" {
    certificate_arn = aws_acm_certificate.tdh-resume-certificate.arn
    validation_record_fqdns = [aws_route53_record.tdh-cert-dns.fqdn]
}

#alias record for cloudfront
resource "aws_route53_record" "cf-record" {
    depends_on = [
        aws_cloudfront_distribution.s3_distribution
    ]

    zone_id = data.aws_route53_zone.tdh-zone.zone_id
    name = "resume.toneherndon.com"
    type = "A"
    alias {
        name = aws_cloudfront_distribution.s3_distribution.domain_name
        zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
        evaluate_target_health = false
    }
}