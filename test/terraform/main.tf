terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "= 3.0.2"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

resource "docker_network" "network" {
  name = var.docker_network
}