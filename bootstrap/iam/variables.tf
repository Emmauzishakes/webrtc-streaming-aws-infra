variable "aws_region" {
  description = "AWS region used for bootstrap resources"
  type        = string
}

variable "terraform_user_name" {
  description = "Terraform deployment user"
  type        = string
}

variable "terraform_group_name" {
  description = "Terraform deployment group"
  type        = string
}