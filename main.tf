resource "aws_lambda_function" "this" {
    function_name = local.function_name

    filename = data.archive_file.source.output_path
    runtime = local.runtime
    handler = "main.handler"
    source_code_hash = data.archive_file.source.output_base64sha256
    role = aws_iam_role.this.arn
    publish = true

    environment {
        variables = {
            LB_TARGET_GROUP_ARN = var.lb_target_group_arn
            RDS_HOST_FQDN = var.rds_host_fqdn
            LAMBDA_LOG_LEVEL = var.lambda_log_level
            MAX_RETRIES = var.max_retries
            RETRY_INTERVAL_SECONDS = var.retry_interval_seconds
        }
    }

}

resource "aws_cloudwatch_log_group" "this" {
    name = "/aws/lambda/${aws_lambda_function.this.function_name}"
    retention_in_days = 14
    skip_destroy = false
}

resource "aws_lambda_permission" "sns" {
    function_name = aws_lambda_function.this.function_name
    #qualifier = aws_lambda_function.this.version

    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    principal = "sns.amazonaws.com"
    source_arn = aws_sns_topic.this.arn
}

# Invoque function
data "aws_lambda_invocation" "this" {
    function_name = aws_lambda_function.this.function_name
    input = <<EOJSON
    {
        "Origin": "terraform invocation of function ${local.function_name}"
    }
    EOJSON
}