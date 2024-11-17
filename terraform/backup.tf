data "docker_image" "backup_postgres" {
  name = var.backup_docker_postgres_image
}

data "docker_image" "backup_aws" {
  name = var.backup_docker_aws_image
}

# Script to run the backup script as a Docker container
resource "local_file" "backup_script" {
  filename = "${var.backup_install_path}/wikijs-backup.sh"
  content = templatefile("./backup/backup.sh.tftpl", {
    TF_SCRIPT_NAME           = var.backup_script_name
    TF_ARCHIVE_NAME          = var.backup_archive_name
    TF_S3_BACKUP_BUCKET      = var.backup_s3_bucket
    TF_POSTGRES_IMAGE        = data.docker_image.backup_postgres.name
    TF_AWS_CLI_IMAGE         = data.docker_image.backup_aws.name
    TF_BACKUP_TMP_DIR        = abspath(var.backup_tmp_dir)
    TF_DOCKER_NETWORK        = var.docker_network
    TF_POSTGRES_HOST         = var.wikijs_db_host
    TF_POSTGRES_PORT         = var.wikijs_db_port
    TF_POSTGRES_USER         = var.wikijs_db_username
    TF_POSTGRES_PASSWORD     = var.wikijs_db_password
    TF_POSTGRES_DB           = postgresql_database.wikijs.name
    TF_WIKIJS_CONTAINER_NAME = docker_container.wikijs.name
  })
}

# Make the backup script executable
resource "null_resource" "backup_chmod" {
  provisioner "local-exec" {
    command = "chmod +x ${local_file.backup_script.filename}"
  }

  triggers = {
    md5 = local_file.backup_script.content_md5
  }

  depends_on = [local_file.backup_script]
}

# Script to run the backup script as a Docker container
resource "local_file" "restore_script" {
  filename = "${var.backup_install_path}/wikijs-restore.sh"
  content = templatefile("./backup/restore.sh.tftpl", {
    TF_SCRIPT_NAME           = var.backup_script_name
    TF_ARCHIVE_NAME          = var.backup_archive_name
    TF_S3_BACKUP_BUCKET      = var.backup_s3_bucket
    TF_POSTGRES_IMAGE        = data.docker_image.backup_postgres.name
    TF_AWS_CLI_IMAGE         = data.docker_image.backup_aws.name
    TF_BACKUP_TMP_DIR        = abspath(var.backup_tmp_dir)
    TF_DOCKER_NETWORK        = var.docker_network
    TF_POSTGRES_HOST         = var.wikijs_db_host
    TF_POSTGRES_PORT         = var.wikijs_db_port
    TF_POSTGRES_USER         = var.wikijs_db_username
    TF_POSTGRES_PASSWORD     = var.wikijs_db_password
    TF_POSTGRES_DB           = postgresql_database.wikijs.name
    TF_WIKIJS_CONTAINER_NAME = docker_container.wikijs.name
  })
}

# Make the backup script executable
resource "null_resource" "restore_chmod" {
  provisioner "local-exec" {
    command = "chmod +x ${local_file.restore_script.filename}"
  }

  triggers = {
    md5 = local_file.restore_script.content_md5
  }

  depends_on = [local_file.restore_script]
}