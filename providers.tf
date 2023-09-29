# configure aws provider to establish a secure connection between terraform and aws
provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      "Automation"  = "terraform"
      "Project"     = var.project_name
      "Environment" = var.environment
    }
  }
}


terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.5"
    }
    http = {
      source = "hashicorp/http"
      #version = "2.1.0"
      version = "~> 2.1"
    }
  }
}

provider "kubernetes" {
  # Configuration options
  config_path    = "~/.kube/config"
  config_context = var.config_context
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" 
    # cluster_ca_certificate = "base64decode(arn:aws:iam::231299874646:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/FBD497C3C3B543A7B1E387276C02E0AE)"
  }
}
