variable "ami" {
  type = string
  #description "AMI ID"
}

variable "instance_type" {
  type = string
  #description = "Instance Type"
}

variable "iam_instance_profile" {
  type = string
  #description = "IAM Instance Profile"
}

variable "public_subnet_id" {
  type = string
}

variable "public_security_group_ids" {
  type = list(string)
}

variable "bridge_subnet_id" {
  type = string
}

variable "bridge_security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}
