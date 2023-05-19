provider "aws" {
    region = "us-east-2"
    profile = "tone.herndon.adm"
}

resource "aws_instance" "test-example" {
    ami         = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
}