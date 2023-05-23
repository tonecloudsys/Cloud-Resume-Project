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
    bucket = aws_s3_bucket.site.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}
resource "aws_s3_bucket_public_access_block" "site" {
    bucket = aws_s3_bucket.site.id

    block_public_acls =         false
    block_public_policy =       false
    ignore_public_acls =        false
    restrict_public_buckets =   false
    
}

resource "aws_s3_bucket_website_configuration" "site" {
    bucket = aws_s3_bucket.site.id

    index_document {
        suffix = "index-html"
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