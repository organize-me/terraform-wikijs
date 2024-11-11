#!/bin/sh
# Environment Variables for test environment
# Run as a dot script: . ./env.sh


# -= Docker =-
export TF_VAR_docker_network="test"

# Docker Desktop Daemon Socket
export TF_VAR_docker_host="unix://$HOME/.docker/desktop/docker.sock"

# -= Postgres Database =-
export TF_VAR_postgres_root_user="postgres"
export TF_VAR_postgres_root_password="password"

# -= Wikijs =-
export TF_VAR_wikijs_db_host="postgres"
export TF_VAR_wikijs_db_port="5432"
export TF_VAR_wikijs_db_username="wikijs"
export TF_VAR_wikijs_db_password="password"