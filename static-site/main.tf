terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider aws {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.env_name
      Client     = var.client
    }
  }
}