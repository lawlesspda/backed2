provider "aws" {
  region  = "us-east-1"
  profile = "default"

}

resource "aws_instance" "example" {
  ami             = "ami-0453ec754f44f9a4a"
  instance_type   = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.allow_8080.id ]

  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo yum install httpd -y
            sudo systemctl start httpd
            sudo systemctl enable httpd
            echo "<h1>Welcome to the Web Server - Deployed via Terraform</h1>" > /var/www/html/index.html
            EOF

  tags = {
    Name = "terraform example"
  }

}

resource "aws_security_group" "allow_8080" {
  name        = "allow-8080"
  description = "Allow inbound traffic on port 8080"

  ingress {
    description = "Allow HTTP traffic on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows traffic from all IPs
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

}
