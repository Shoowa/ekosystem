terraform {
  required_version = "~> 1.0"

  required_providers {

    aws         = {
      version   = ">= 4.0"
      source    = "hashicorp/aws"
    }

    kubernetes  = {
      version   = ">= 2.0"
      source    = "hashicorp/kubernetes"
    }

    helm        = {
      version   = ">= 2.0"
      source    = "hashicorp/helm"
    }

  }

  backend "s3" {
    profile         = "arch"
    bucket          = "blueprint-us-east-2-production-assymblur"
    key             = "dev/ops/ekosystem/terraform.tfstate"
    region          = "us-east-2" 
    
    dynamodb_table  = "blueprint-us-east-2-production-assymblur"
    encrypt         = true
  }

}

provider "aws" {
    shared_config_files       = ["~/.aws/config"]
    shared_credentials_files  = ["~/.aws/credentials"]
    profile                   = "arch"
    region                    = "us-east-2"

    default_tags {
      tags          = {
        Environment = "dev"
        Service     = "ops"
        Dept        = "sre"
        test        = true
      }
    }
}


data "aws_eks_cluster" "test" {
  name = "test-1"
}


provider "kubernetes" {
  host = data.aws_eks_cluster.test.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.test.certificate_authority.0.data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.test.name]
  }
}


provider "helm" {
  kubernetes {
    host = data.aws_eks_cluster.test.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.test.certificate_authority.0.data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.test.name]
    }
  }
}
