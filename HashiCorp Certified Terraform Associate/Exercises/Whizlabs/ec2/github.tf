terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.42.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

# resource "github_repository" "repo" {
#   name       = "test-repo"
#   visibility = "private"
# }
