# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
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

# Create a Security Group
resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.appvpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a Launch Configuration
resource "aws_launch_configuration" "terraform" {
  name                  = "terraform-launch-configuration"
  image_id              = "ami-0f58b397bc5c1f2e8"  # Replace with your desired AMI ID
  instance_type         = "t2.micro"
  iam_instance_profile  = aws_iam_instance_profile.ec2_instance_profile.name
  security_groups       = [aws_security_group.instance.id]
  lifecycle {
    create_before_destroy = true
  }
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "terraform" {
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.terraform.name
  vpc_zone_identifier       = [aws_subnet.terraform.id]
  tag {
    key                 = "Name"
    value               = "terraform-instance"
    propagate_at_launch = true
  }
}

# Create an IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# Output the public IP address of the first instance in the Auto Scaling Group
output "instance_ip" {
  value = aws_instance.terraform.public_ip
}

# Create an EC2 Instance
resource "aws_instance" "terraform" {
  ami                    = "ami-0f58b397bc5c1f2e8"  # Replace with your desired AMI ID
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.terraform.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  security_groups        = [aws_security_group.instance.name]
  tags = {
    Name = "terraform-instance"
  }
}

# Output the instance IP address
output "instance_ip" {
  value = aws_instance.terraform.public_ip
}
