locals {
  resource_prefix = "nlb-target"
  function_name = var.function_name != null ? var.function_name : "${local.resource_prefix}-updater"
  lambda_file_name = "${local.function_name}-source.zip"
  runtime = "python3.11"
  implicit_invoke = lower(var.lambda_log_level) == "debug" ? 1 : 0
}
