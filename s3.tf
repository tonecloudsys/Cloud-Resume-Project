provider "aws" {
    region  =  "us-east-1"
    profile = "tone.herndon.adm"
}
resource "aws_s3_bucket" "resume-website" {
    bucket = "my-tf-resume-bucket"

    tags = {
        Name       = "Tone bucket"
    }
   
}

resource "aws_s3_object" "index-html" {
    bucket = "resume-website"
    key    = "new_object_key"
    source = "index-html"
    etag   = filemd5("index-html")
}
