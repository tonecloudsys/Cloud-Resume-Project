provider "aws" {
    region  =  "us-east-1"
    profile = "tone.herndon.adm"
}

resource "aws_s3_bucket" "static" {
    bucket = "my-tf-tdh-resume-bucket"

    tags = {
        Name       = "Tone bucket"
    }
}
