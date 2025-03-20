# core
variable "developer_initals" {
  type        = string
  description = "initial of the developer using this code, to provide ownership tag"
}

variable "public_key_file_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "us-east-2"
}

variable "local_ipv4_address" {
  type = string

  validation {
    condition     = can(cidrhost(var.local_ipv4_address, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}


variable "local_ipv6_address" {
  type = string

  nullable = true
  validation {
    condition     = can(cidrhost(var.local_ipv6_address, 0))
    error_message = "Must be valid IPv4 CIDR."
  }
}



# vpc setup variables

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
