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

# WikiJS Variables
variable "wikijs_image" {
  type = string
  default = "requarks/wiki:2.5.300"
}
variable "wikijs_db_host" {
  description = "The host used to connect to PostgreSQL from the wikijs container"
  type        = string
}
variable "wikijs_db_port" {
  description = "The port used to connect to PostgreSQL from the wikijs container"
  type        = string
}
variable "wikijs_db_username" {
  description = "The username used to connect to PostgreSQL from the wikijs container"
  type = string
}
variable "wikijs_db_password" {
  description = "The password used to connect to PostgreSQL from the wikijs container"
  type = string
}

# PostgreSQL Variables
variable "postgres_root_user" {
  description = "The PostgreSQL root username"
  type        = string
}

variable "postgres_root_password" {
  description = "The PostgreSQL root password"
  type        = string
}

variable "postgres_host" {
  description = "The PostgreSQL host from the terraform provider"
  type        = string
  default     = "localhost"
}

variable "postgres_port" {
  description = "The PostgreSQL port"
  type        = number
  default     = 5432
}