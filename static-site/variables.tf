variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "client" {
  description = "Client name"
  type        = string
  default     = "git"
}

variable "env_name" {
  description = "Environment name, such as stage, prod etc"
  type        = string
  default     = "test"
}

variable domain {
description = "AWS R53 domain"
  type        = string
}

variable sub_domain {
description = "AWS R53 sub domain"
  type        = string
}

variable frontend_certificate_arn {
  description = "Frontend aws certificate"
}