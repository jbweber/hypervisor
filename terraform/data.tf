data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_ssm_parameter" "amazon_linux_ami_x86_64" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}