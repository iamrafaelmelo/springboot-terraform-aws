# -----------------------------------------------------------------------------
# Provider
# -----------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

# -----------------------------------------------------------------------------
# Security Groups
# -----------------------------------------------------------------------------
resource "aws_security_group" "allow_http_access" {
  name        = "allow-http-access"
  description = "Allow HTTP internet access"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    ProvisionedBy = "terraform"
  }
}

resource "aws_security_group" "allow_https_access" {
  name        = "allow-https-access"
  description = "Allow HTTPS internet access"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    ProvisionedBy = "terraform"
  }
}

resource "aws_security_group" "allow_ssh_access" {
  name        = "allow-ssh-access"
  description = "Allow SSH access"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["<your-ip>"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["<your-ip>"]
  }
  tags = {
    ProvisionedBy = "terraform"
  }
}

# -----------------------------------------------------------------------------
# Key Pairs
# -----------------------------------------------------------------------------
resource "aws_key_pair" "webserver_keypair" {
  key_name   = "webserver-keypair"
  public_key = file("~/.ssh/id_rsa.pub") # default ssh-keygen store path
  tags = {
    ProvisionedBy = "terraform"
  }
}

# -----------------------------------------------------------------------------
# Instances
# -----------------------------------------------------------------------------
resource "aws_instance" "webserver" {
  ami           = "ami-0157af9aea2eef346"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.webserver_keypair.key_name
  user_data     = file("userdata.sh")
  vpc_security_group_ids = [
    aws_security_group.allow_http_access.id,
    aws_security_group.allow_https_access.id,
    aws_security_group.allow_ssh_access.id,
  ]
  tags = {
    Name          = "webserver"
    ProvisionedBy = "terraform"
  }
}
