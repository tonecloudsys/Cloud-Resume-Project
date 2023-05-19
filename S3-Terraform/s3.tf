
provider "aws" {
    region  =  "us-east-1"
    profile = "tone.herndon.adm"
}
resource "aws_s3_object" "default" {
    bucket = "my-tf-tdh-resume-bucket"
    key    = "index-html"
    source = "index-html"
    etag   = filemd5("index-html")
}


