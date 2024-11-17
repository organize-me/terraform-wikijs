resource "docker_image" "wikijs" {
  name         = var.wikijs_image
}

resource "docker_container" "wikijs" {
  image         = docker_image.wikijs.image_id
  name          = "organize-me-wikijs"
  hostname      = "wikijs"
  restart       = "unless-stopped"
  network_mode  = "bridge"

  env   = [
    "TZ=${var.timezone}",
    "DB_TYPE=postgres",
    "DB_HOST=${var.wikijs_db_host}",
    "DB_PORT=${var.wikijs_db_port}",
    "DB_USER=${var.wikijs_db_username}",
    "DB_PASS=${var.wikijs_db_password}",
    "DB_NAME=${postgresql_database.wikijs.name}",
  ]
  networks_advanced {
    name    = data.docker_network.network.name
    aliases = ["wikijs"]
  }
  ports {
    internal = 3000
    external = 3000
  }

  depends_on = [
    postgresql_database.wikijs,
    postgresql_role.wikijs,
    postgresql_grant.wikijs
  ]
}
