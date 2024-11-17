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
  default = "requarks/wiki:2.5"
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

# Backup/Restore Variables
variable "backup_docker_postgres_image" {
  description = "The Docker image used to backup the PostgreSQL database"
  type        = string
  default     = "postgres:17"
}

variable "backup_docker_aws_image" {
  description = "The Docker image used to backup the PostgreSQL database to AWS S3"
  type        = string
  default     = "amazon/aws-cli:2.18.9"
}

variable "backup_install_path" {
  description = "The path to install the backup/restore scripts"
  type        = string
  default     = "../bin"
}

variable "backup_script_name" {
  description = "The name of the backup script"
  type        = string
  default     = "backup.sql"
}

variable "backup_archive_name" {
  description = "The name of the backup archive"
  type        = string
  default     = "wikijs-backup.tar.gz"
}

variable "backup_s3_bucket" {
  description = "The S3 bucket to store the backup archive"
  type        = string
  default     = "none"
}

variable "backup_tmp_dir" {
  description = "The temporary directory to store the backup archive"
  type        = string
  default     = "../tmp"
}
