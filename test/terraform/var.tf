# General Variables
variable "timezone" {
  type = string
  default = "America/Los_Angeles"
}

# Docker Variables
variable "docker_host" {
  default = "unix:///var/run/docker.sock"
}
variable "docker_network" {
  type = string
}

# PostgreSQL Variables
variable "backup_docker_postgres_image" {
  type = string
  default = "postgres:17"
}
variable "postgres_root_user" {
  description = "The PostgreSQL username"
  type        = string
}
variable "postgres_root_password" {
  description = "The PostgreSQL password"
  type        = string
}

# MinIO Variables
variable "docker_minio_image" {
  type = string
}
variable "minio_root_user" {
  description = "The MinIO username"
  type        = string
}
variable "minio_root_password" {
  description = "The MinIO password"
  type        = string
}
variable "backup_s3_bucket" {
  description = "The S3 bucket to store backups"
  type        = string
}

# AWS
variable "backup_docker_aws_image" {
  type = string
}