locals {
  resource_prefix       = var.resource_prefix != null ? var.resource_prefix : "nlb-target"
  function_name         = var.function_name != null ? var.function_name : "${local.resource_prefix}-updater"
  lambda_file_name      = "${local.function_name}-source.zip"
  runtime               = "python3.11"
  implicit_invoke       = lower(var.lambda_log_level) == "debug" || var.invoke_from_terraform == true ? 1 : 0
  default_rds_events = [
    "availability",
    "failover",
    "failure",
    "maintenance",
    "recovery",
    "restoration",
  ]
  rds_events = distinct(concat(local.default_rds_events, var.extra_rds_events))
}
