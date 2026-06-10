resource "aws_security_group" "ec2_sg" {

  name        = "ec2-s3-script-sg"
  description = "Allow SSH access"

  ingress {
    description = "SSH"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-s3-script-sg"
  }
}

resource "aws_instance" "server" {

  ami           = "ami-091138d0f0d41ff90"
  instance_type = "t3.micro"

  key_name = "shell-scripts-key.pem"

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
#!/bin/bash

exec > /var/log/user-data.log 2>&1

aws s3 cp s3://shells-scripts-pfizer-2027/hello.sh /tmp/hello.sh

chmod +x /tmp/hello.sh

/tmp/hello.sh

EOF
  tags = {
    Name = "s3-script-server"
  }
}