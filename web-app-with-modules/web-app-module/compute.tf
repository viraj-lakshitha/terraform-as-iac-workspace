resource "aws_instance" "instance_1" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance_security_group.name]
  user_data       = <<-EOF
          #!/bin/bash
          echo "Hello, World!" > index.html
          python3 -m http.server 8080 &
          EOF
}

resource "aws_instance" "instance_2" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance_security_group.name]
  user_data       = <<-EOF
          #!/bin/bash
          echo "Hello, World!" > index.html
          python3 -m http.server 8080 &
          EOF
}
