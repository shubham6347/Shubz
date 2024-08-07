provider "aws" {
  access_key = "AKIAXSVYV7RTTKNAACQB"  # Replace with your access key
  secret_key = "wqDLKY8WvDIDdd8FCH8G+gAoD2KRLWnc4z4SfqE3"  # Replace with your secret key
  region = "ap-south-1"
}




# Launch an EC2 instance using the new Key Pair
resource "aws_instance" "example" {
  ami           = "ami-0f58b397bc5c1f2e8"  # Replace with your AMI ID
  instance_type = "t2.micro"
  key_name      = "newjenkins"

  tags = {
    Name = "example-instance"
  }
}
