# Configure the AWS Provider
provider "aws" {
  region     = "ap-south-1"
  
}

# Create an IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach a Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Create a VPC
resource "aws_vpc" "appvpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a Public Subnet
resource "aws_subnet" "terraform" {
  vpc_id            = aws_vpc.appvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
}

# Create an EC2 Instance
resource "aws_instance" "terraform" {
  ami           = "ami-0f58b397bc5c1f2e8"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.terraform.id
  tags = {
    Name = "terraform-instance"
  }
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "terraform" {
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.terraform.name
  vpc_zone_identifier       = [aws_subnet.terraform.id]
}

# Create a Launch Configuration
resource "aws_launch_configuration" "terraform" {
  name          = "terraform-launch-configuration"
  image_id      = "ami-0f58b397bc5c1f2e8"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
}


