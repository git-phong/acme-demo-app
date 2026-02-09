provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

data "tfe_outputs" "source_workspace" {
  workspace    = var.workspace_name
  organization = var.organization_name
}

resource "aws_security_group" "allow_ping" {
  name        = "allow_ping"
  description = "Allow ICMP traffic to the instance"
  vpc_id      = data.tfe_outputs.source_workspace.nonsensitive_values.vpc_id

  ingress {
    description      = "Allow ICMP traffic from the VPC CIDR block"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = "0.0.0/0"
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0/0"
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = true

  vpc_security_group_ids = [data.tfe_outputs.source_workspace.nonsensitive_values.vpc_security_group_ids, aws_security_group.allow_ping.id]
  subnet_id              = data.tfe_outputs.source_workspace.nonsensitive_values.vpc_subnet[0]

  tags = {
    Name = var.instance_name
  }
}
