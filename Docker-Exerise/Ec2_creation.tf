#Configure AWS Provider

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "docker_path" {
  ami                    = "ami-0db56f446d44f2f09" 
  instance_type          = "t3.micro"
  count                  = 1
  key_name               = "linux-first"
  subnet_id              = "subnet-0ad2867d383236c46"
  vpc_security_group_ids = ["sg-0f57a6695f1eb7f85"]

  tags = {
    Name = "Docker-ec2"
  }
}

output "ec2_public_ips" {
  value = aws_instance.docker_path[*].public_ip
}