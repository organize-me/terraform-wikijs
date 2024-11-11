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
variable "postgres_root_user" {
  description = "The PostgreSQL username"
  type        = string
}

variable "postgres_root_password" {
  description = "The PostgreSQL password"
  type        = string
}
