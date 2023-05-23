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
resource "aws_s3_bucket_public_access_block" "public-access" {
    bucket = "my-tf-tdh-resume-bucket"

    block_public_acls =         false
    block_public_policy =       false
    ignore_public_acls =        false
    restrict_public_buckets =   false
    
}

resource "aws_s3_bucket_website_configuration" "site" {
    bucket = "my-tf-tdh-resume-bucket"

    index_document {
        suffix = "index-html"
    }

}
resource "aws_s3_bucket_acl" "site-acl" {
    bucket = "my-tf-tdh-resume-bucket"

    acl    = "public-read"
  
}