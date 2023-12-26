data "template_file" "aws_init_script" {
  template = file("init-script.tpl")
  vars = {
    workload_name = format("AWS-%s", local.workload_name)
  }
}

resource "aws_security_group" "test" {
  name        = format("%s-sg", local.workload_name)
  description = "SG to alllow traffic from the Azure VNet"
  vpc_id      = var.aws_vpc_id

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [var.azure_vnet_cidr]
  }

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [var.aws_vpc_cidr]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "nic" {
  subnet_id       = element(var.aws_workload_subnet_ids, 0)
  private_ips     = [var.aws_vm_private_ip]
  security_groups = [aws_security_group.test.id]

  tags = {
    Name = format("%s-nic", local.workload_name)
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "test_vm_key" {
  key_name   = format("%s-key", local.workload_name)
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_instance" "aws_test_vm" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"

  network_interface {
    network_interface_id = aws_network_interface.nic.id
    device_index         = 0
  }

  key_name  = aws_key_pair.test_vm_key.key_name
  user_data = data.template_file.aws_init_script.rendered

  tags = {
    Name = format("%s-vm", local.workload_name)
  }
}