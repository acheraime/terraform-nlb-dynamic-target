locals {
  function_name = "nlb-target-update"
  lambda_file_name = "nlb-target.zip"
  runtime = "python3.11"
  implicit_invoke = lower(var.lambda_log_level) == "debug" ? 1 : 0
}
