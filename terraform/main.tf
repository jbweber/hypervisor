resource "random_id" "unique_id" {
  byte_length = 6
}

locals {
  local_source_ipv4_addresses = [var.local_ipv4_address]
  local_source_ipv6_addresses = var.local_ipv6_address != null ? [var.local_ipv6_address] : []
  tags = merge(
    tomap({
      "created-by" : "hypervisor",
      "developer_initials" : var.developer_initals,
      "unique_id" : local.unique_id,
    }),
    var.tags
  )
  unique_id = random_id.unique_id.hex
}

resource "aws_key_pair" "key_pair" {
  key_name   = "key-${local.unique_id}"
  public_key = file(var.public_key_file_path)

  tags = local.tags
}

