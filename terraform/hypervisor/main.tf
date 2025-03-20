resource "aws_network_interface" "public" {
  subnet_id       = var.public_subnet_id
  security_groups = var.public_security_group_ids
}

resource "aws_network_interface" "bridge" {
  subnet_id       = var.bridge_subnet_id
  security_groups = var.bridge_security_group_ids
  ipv4_prefix_count = 0
  ipv6_prefix_count = 0
}

resource "aws_instance" "this" {
  ami                  = var.ami
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile

  #    user_data = var.user_data
  #    user_data_base64 = var.user_data_base64
  #    user_data_replace_on_change = var.user_data_replace_on_change

  #    availability_zone = var.availability_zone
  #    subnet_id = var.subnet_id
  #    vpc_security_group_ids = var.vpc_security_group_ids

  key_name = var.key_name
  #    monitoring = var.monitoring
  #    get_password_data = var.get_password_data


  #    associate_public_ip_address = var.associate_public_ip_address
  #    private_ip = var.private_ip
  #    secondary_private_ips = var.secondary_private_ips
  #      ipv6_address_count          = var.ipv6_address_count
  #  ipv6_addresses              = var.ipv6_addresses

  network_interface {
    delete_on_termination = false
    device_index          = 0
    network_interface_id  = aws_network_interface.public.id
  }


  network_interface {
    delete_on_termination = false
    device_index          = 1
    network_interface_id  = aws_network_interface.bridge.id
  }

  root_block_device {
    volume_size = 100
  }

}