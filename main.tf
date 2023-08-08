# Create S3 object from the archived code
resource "aws_s3_object" "source" {
    bucket = data.aws_s3_bucket.bucket.id
    key = local.lambda_file_name
    source = data.archive_file.source.output_path
    etag = filemd5(data.archive_file.source.output_path)
}

resource "aws_lambda_function" "this" {
    function_name = local.function_name

    s3_bucket = data.aws_s3_bucket.bucket.id
    s3_key = local.lambda_file_name
    runtime = "python3.11"
    handler = "main.handler"
    source_code_hash = data.archive_file.source.output_base64sha256
    role = aws_iam_role.this.arn
}

resource "aws_cloudwatch_log_group" "this" {
    name = "/aws/lambda/${aws_lambda_function.this.function_name}"
    retention_in_days = 14
}


# Invoque function
data "aws_lambda_invocation" "this" {
    function_name = aws_lambda_function.this.qualified_arn
    input = <<EOJSON
    {
        "Origin": "terraform invocation of function ${local.function_name}"
    }
    EOJSON
}