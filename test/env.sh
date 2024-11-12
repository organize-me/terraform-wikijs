#!/bin/sh
# Environment Variables for test environment
# Run as a dot script: . ./env.sh

# Set the aws-cli environment variables
export AWS_ACCESS_KEY_ID="minioadmin"
export AWS_SECRET_ACCESS_KEY="minioadmin"
export AWS_S3_ENDPOINT_URL="http://host.docker.internal:9000"

# -= Docker =-
export TF_VAR_docker_network="test"
export TF_VAR_docker_host="unix://$HOME/.docker/desktop/docker.sock"
export TF_VAR_backup_docker_postgres_image="postgres:17"
export TF_VAR_postgres_root_user="postgres"
export TF_VAR_postgres_root_password="password"
export TF_VAR_docker_minio_image="minio/minio:latest"
export TF_VAR_minio_root_user="$AWS_ACCESS_KEY_ID"
export TF_VAR_minio_root_password="$AWS_SECRET_ACCESS_KEY"
export TF_VAR_wikijs_db_host="postgres"
export TF_VAR_wikijs_db_port="5432"
export TF_VAR_wikijs_db_username="wikijs"
export TF_VAR_wikijs_db_password="password"
export TF_VAR_backup_docker_aws_image="amazon/aws-cli:2.18.9"
export TF_VAR_backup_s3_bucket="wikijs-test-bucket"
export TF_VAR_backup_postgres_image="$TF_VAR_docker_postgres_image"