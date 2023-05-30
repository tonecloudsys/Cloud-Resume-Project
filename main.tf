provider "aws" {
    region  =  "us-east-1"
    profile = "tone.herndon.adm"
}

resource "aws_s3_bucket" "site" {
    bucket = "my-tf-tdh-resume-bucket"

    tags = {
        Name       = "Tone bucket"
    }
}
resource "aws_s3_bucket_ownership_controls" "site" {
    bucket = aws_s3_bucket.site.bucket
    rule {
        object_ownership         = "BucketOwnerPreferred"
    }
}
resource "aws_s3_bucket" "logs" {
    bucket = "tdh-cloudfront-logs"

    tags = {
        Name       = "Log bucket"
    }
}
resource "aws_s3_bucket_ownership_controls" "logs" {
    bucket = aws_s3_bucket.logs.bucket
    rule {
        object_ownership         = "BucketOwnerPreferred"
    }
}
resource "aws_s3_bucket_public_access_block" "site" {
    bucket = aws_s3_bucket.site.bucket

    block_public_acls       =         false
    block_public_policy     =       false
    ignore_public_acls      =        false
    restrict_public_buckets =   false
    
}

resource "aws_s3_bucket_website_configuration" "site" {
    bucket = aws_s3_bucket.site.bucket

    index_document {
        suffix = "index.html"
    }

}
resource "aws_s3_bucket_acl" "site" {
    depends_on = [
        aws_s3_bucket_ownership_controls.site,
        aws_s3_bucket_public_access_block.site,
        
    ]

    bucket = aws_s3_bucket.site.id
    acl    = "public-read" 
}
resource "aws_s3_object" "site" {
    depends_on = [
        aws_s3_bucket_acl.site
    ]
    bucket       = aws_s3_bucket.site.bucket
    key          = "index.html"
    content_type = "text/html"
    acl          = "public-read"
    source       = "C:/Users/tone.herndon/Git/Cloud-Resume-Project/index.html"
    etag         = filemd5("C:/Users/tone.herndon/Git/Cloud-Resume-Project/index.html")
}
locals {
    s3_origin_id = "ToneS3Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name                     = aws_s3_bucket.site.bucket_regional_domain_name
        origin_id                       = local.s3_origin_id
    }
    enabled = true
    is_ipv6_enabled = true
    comment = "Some comment"
    default_root_object = "index.html"


    default_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id

        viewer_protocol_policy = "allow-all"
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
        cloudfront_default_certificate = true
    }

}
