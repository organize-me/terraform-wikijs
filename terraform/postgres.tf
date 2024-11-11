provider "postgresql" {
  host = var.postgres_host
  port = var.postgres_port
  username = var.postgres_root_user
  password = var.postgres_root_password
  sslmode = "disable"

}

# Create the SonarQube database
resource "postgresql_database" "wikijs" {
  name = var.wikijs_db_username
}

# Create a PostgreSQL user
resource "postgresql_role" "wikijs" {
  name     = var.wikijs_db_username
  password = var.wikijs_db_password
  login    = true
}

# Grant privileges to the PostgreSQL user
resource "postgresql_grant" "wikijs" {
  role        = postgresql_role.wikijs.name
  database    = postgresql_database.wikijs.name
  schema      = "public"
  object_type = "schema"
  privileges  = ["CREATE", "USAGE"]
}
