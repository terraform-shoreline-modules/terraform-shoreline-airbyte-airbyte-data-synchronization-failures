resource "shoreline_notebook" "airbyte_data_synchronization_failures" {
  name       = "airbyte_data_synchronization_failures"
  data       = file("${path.module}/data/airbyte_data_synchronization_failures.json")
  depends_on = [shoreline_action.invoke_restart_sync_script,shoreline_action.invoke_rollback_previous_deployment]
}

resource "shoreline_file" "restart_sync_script" {
  name             = "restart_sync_script"
  input_file       = "${path.module}/data/restart_sync_script.sh"
  md5              = filemd5("${path.module}/data/restart_sync_script.sh")
  description      = "Restart the data synchronization process to ensure that it is running correctly and that any errors have been resolved."
  destination_path = "/tmp/restart_sync_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "rollback_previous_deployment" {
  name             = "rollback_previous_deployment"
  input_file       = "${path.module}/data/rollback_previous_deployment.sh"
  md5              = filemd5("${path.module}/data/rollback_previous_deployment.sh")
  description      = "If necessary, roll back to a previous version of the data synchronization process to restore any lost data and prevent further data loss."
  destination_path = "/tmp/rollback_previous_deployment.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_restart_sync_script" {
  name        = "invoke_restart_sync_script"
  description = "Restart the data synchronization process to ensure that it is running correctly and that any errors have been resolved."
  command     = "`chmod +x /tmp/restart_sync_script.sh && /tmp/restart_sync_script.sh`"
  params      = ["NAMESPACE","DEPLOYMENT_NAME"]
  file_deps   = ["restart_sync_script"]
  enabled     = true
  depends_on  = [shoreline_file.restart_sync_script]
}

resource "shoreline_action" "invoke_rollback_previous_deployment" {
  name        = "invoke_rollback_previous_deployment"
  description = "If necessary, roll back to a previous version of the data synchronization process to restore any lost data and prevent further data loss."
  command     = "`chmod +x /tmp/rollback_previous_deployment.sh && /tmp/rollback_previous_deployment.sh`"
  params      = ["NAMESPACE","DEPLOYMENT_NAME"]
  file_deps   = ["rollback_previous_deployment"]
  enabled     = true
  depends_on  = [shoreline_file.rollback_previous_deployment]
}

