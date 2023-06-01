locals {
    s3_origin_id = "ToneS3Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name                     = aws_s3_bucket.site.bucket_regional_domain_name
        origin_id                       = local.s3_origin_id
    }
    aliases = ["resume.toneherndon.com"]
    
    enabled = true
    is_ipv6_enabled = true
    comment = "Some comment"
    default_root_object = "index.html"



    default_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400


    
    forwarded_values {
        query_string = false
        headers      = ["Origin"]

        cookies {
            forward = "none"
        }
    }
    
    }
    

    restrictions {
        geo_restriction {
            restriction_type = "whitelist"
            locations        = ["US", "CA", "GB", "DE"]
        }
    }

    tags = {
        Environment = "test"
    
    }
    viewer_certificate {
        acm_certificate_arn = aws_acm_certificate_validation.tdh-cert-validate.certificate_arn
        ssl_support_method = "sni-only"
    }

}
