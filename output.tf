output "function_arn" {
  description = "Amazon Resource Name (ARN) of the Lambda Function"
  value       = aws_lambda_function.this.arn
}

output "function_invoke_arn" {
  description = "ARN to be used for invoking Lambda Function from API Gateway"
  value       = aws_lambda_function.this.invoke_arn
}

output "function_version" {
  description = "Latest published version of the Lambda Function"
  value       = aws_lambda_function.this.version
}

output "function_role_arn" {
  description = "ARN for the IAM role attached to the Lambda Fnction"
  value       = aws_iam_role.this.arn
}
