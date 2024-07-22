variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_public_1" {
  description = "CIDR block for the public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_public_2" {
  description = "CIDR block for the public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet_private_1" {
  description = "CIDR block for the private subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "subnet_private_2" {
  description = "CIDR block for the private subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}
