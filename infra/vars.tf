variable "region" {
  type        = string
  default     = "eu-west-3"
  description = "AWS region to deploy to"
}

variable "stage" {
  type        = string
  default     = "dev"
  description = "Ressource group"
}

variable "profile" {
  type    = string
  default = "default"
}
