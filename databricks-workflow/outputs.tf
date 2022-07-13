output "databricks_host" {
  value = "https://${data.azurerm_databricks_workspace.dbw.workspace_url}/"
}

output "databricks_name" {
  value = "${data.azurerm_databricks_workspace.dbw.name}"
}

output "databricks_id" {
  value = "${data.azurerm_databricks_workspace.dbw.id}"
}

output "notebook_url" {
  value = databricks_notebook.this.url
}

output "job_url" {
  value = databricks_job.this.url
}