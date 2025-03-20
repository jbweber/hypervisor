resource "aws_security_group" "public" {
  name   = "hypervisor_sg"
  vpc_id = module.vpc.vpc_id

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress_anywhere" {
  security_group_id = aws_security_group.public.id
  description       = "Reason: allow access to the world"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "ingress_ssh" {
  description       = "Reason: allow ssh access to the instance"
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = local.local_source_ipv4_addresses
  ipv6_cidr_blocks  = local.local_source_ipv6_addresses
}

resource "aws_security_group_rule" "ingress_ping" {
  description       = "Reason: allow ping access to the instance"
  security_group_id = aws_security_group.public.id
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group" "bridge" {
  name   = "bridge_sg"
  vpc_id = module.vpc.vpc_id

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "bridge_egress_anywhere" {
  security_group_id = aws_security_group.bridge.id
  description       = "Reason: allow access to the world"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}


resource "aws_iam_role" "hypervisor" {
  name = "hypervisor-${local.unique_id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_instance_profile" "hypervisor" {
  name = "hypervisor-${local.unique_id}"
  role = aws_iam_role.hypervisor.name

  tags = local.tags
}

module "hypervisor" {
  source = "./hypervisor"

  ami                  = data.aws_ssm_parameter.amazon_linux_ami_x86_64.value
  instance_type        = "m7i.metal-24xl"
  iam_instance_profile = aws_iam_instance_profile.hypervisor.name

  public_subnet_id          = element(module.vpc.public_subnets, 1)
  bridge_subnet_id          = element(module.vpc.private_subnets, 1)
  public_security_group_ids = [aws_security_group.public.id]
  bridge_security_group_ids = [aws_security_group.bridge.id]
  key_name                  = aws_key_pair.key_pair.key_name
}


output "hypervisor" {
  value = module.hypervisor
}