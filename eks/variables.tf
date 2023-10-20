variable "vpc_cidr" {
  description = "VPC CIDR."
  type        = string
}

variable "private_subnets" {
  description = "Private subnets CIDR."
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnets CIDR."
  type        = list(string)
}
