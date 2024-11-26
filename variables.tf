variable "ami" {
  type    = string
  default = "ami-012967cc5a8c9f891"
}

variable "image_repo_name" {
  description = "Image repo name"
  type        = string
  default     = "hpo-api-image"
}

variable "ecr_repo_url" {
  description = "ECS Cluster Name"
  type        = string
  default = "hpo-staging-api-cluster"
}

variable "container_port" {
  description = "ECS Cluster Name"
  type        = string
  default = 3000
}
