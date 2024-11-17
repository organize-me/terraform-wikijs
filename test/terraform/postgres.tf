# This resource pulls the PostgreSQL Docker image with the specified version.
resource "docker_image" "postgres" {
  name = var.backup_docker_postgres_image
}

# This resource creates a Docker container for PostgreSQL.
resource "docker_container" "postgres" {
  # Specifies the Docker image to use for the container.
  image = docker_image.postgres.image_id
  # Names the Docker container.
  name  = "organize-me-postgres-db"
  # Sets the network mode to bridge.
  network_mode = "bridge"
  # Ensures Terraform waits until the container is healthy.
  wait = true

  # Configures the health check for the PostgreSQL container.
  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.postgres_root_user}"]
    interval = "30s"
    timeout  = "10s"
    retries  = 5
  }

  # Maps the internal and external ports for PostgreSQL.
  ports {
    internal = 5432
    external = 5432
  }

  # Sets environment variables for the PostgreSQL container.
  env = [
    "TZ=${var.timezone}",
    "POSTGRES_USER=${var.postgres_root_user}",
    "POSTGRES_PASSWORD=${var.postgres_root_password}"
  ]

  # Configures advanced network settings for the PostgreSQL container.
  networks_advanced {
    name = docker_network.network.name
    aliases = ["postgres"]
  }
}
