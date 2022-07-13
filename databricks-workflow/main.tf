# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.87.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "2.3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.0.1"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Script to clone project for deployment
resource "null_resource" "clone" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "/bin/bash clone.sh"
  }
}

# Command to checkout before deployment
resource "null_resource" "checkout" {
  triggers = {
    order = null_resource.clone.id
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "cd spark-001 && git checkout ${var.BRANCH}"
  }
}

# Random folder to redeploy code and overwrite terraform state
resource "random_string" "folder" {
  special = false
  upper   = false
  keepers = {
    first = "${timestamp()}"
  }
  length = 6
}

# Copy code to databricks workspace with random folder for redeployment overwrite terrafrom state.
resource "databricks_notebook" "this" {
  source = "spark-001/Test001.py"
  path   = "/Shared/${random_string.folder.result}"
  depends_on = [null_resource.checkout]
}

# Due to the above random notebook path this job will be also be redeployed.
resource "databricks_job" "this" {
  name                = "job001"
  existing_cluster_id = "0713-052924-3l3i8nhz"
  notebook_task {
    notebook_path = databricks_notebook.this.path
  }
}

