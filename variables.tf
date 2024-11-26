variable "ami" {
  type    = string
  default = "ami-012967cc5a8c9f891"
}

variable "image_repo_name" {
  description = "Image repo name"
  type        = string
  default     = "hpo-api-image"
}
