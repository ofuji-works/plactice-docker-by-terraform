terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_image" "mysql" {
  name = "mysql:latest"
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.name
  name  = "mysql"
  env = [
    "MYSQL_ROOT_PASSWORD=passw0rd",
    "TZ=Asia/Tokyo"
  ]
  ports {
    internal = 80
    external = 8080
  }
  volumes {
    container_path = "/var/lib/mysql"
    host_path      = "${abspath(path.root)}/data-volume"
    volume_name    = docker_volume.data_volume.name
  }
}

resource "docker_volume" "data_volume" {
  name = "data-volume"
}
