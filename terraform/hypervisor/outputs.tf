output "id" {
  value = aws_instance.this.id
}

output "public_ipv6_address" {
  value = aws_instance.this.ipv6_addresses
}