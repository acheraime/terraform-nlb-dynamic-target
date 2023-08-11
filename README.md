## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.4.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_event_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/db_event_subscription) | resource |
| [aws_iam_policy.extra](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.extra](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.sns](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/resources/sns_topic_subscription) | resource |
| [archive_file.source](https://registry.terraform.io/providers/hashicorp/archive/2.4.0/docs/data-sources/file) | data source |
| [aws_iam_policy_document.extra](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/data-sources/iam_policy_document) | data source |
| [aws_lambda_invocation.this](https://registry.terraform.io/providers/hashicorp/aws/5.11.0/docs/data-sources/lambda_invocation) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_instance_ids"></a> [db\_instance\_ids](#input\_db\_instance\_ids) | List of RDS instances ID | `list(string)` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Lambda Function. | `string` | `null` | no |
| <a name="input_lambda_log_level"></a> [lambda\_log\_level](#input\_lambda\_log\_level) | Log verbosity level of the lambda function | `string` | `"info"` | no |
| <a name="input_lb_target_group_arn"></a> [lb\_target\_group\_arn](#input\_lb\_target\_group\_arn) | ARN of the load balancer target group resource | `string` | n/a | yes |
| <a name="input_max_retries"></a> [max\_retries](#input\_max\_retries) | Maximum times to retry a failed remote call within the range [1-10] | `number` | `3` | no |
| <a name="input_rds_host_fqdn"></a> [rds\_host\_fqdn](#input\_rds\_host\_fqdn) | Fully qualified domain name of the RDS instance | `string` | n/a | yes |
| <a name="input_retry_interval_seconds"></a> [retry\_interval\_seconds](#input\_retry\_interval\_seconds) | Interval time in seconds to wait before retry a failed remote call | `number` | `5` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | Amazon Resource Name (ARN) of the Lambda Function |
| <a name="output_function_invoke_arn"></a> [function\_invoke\_arn](#output\_function\_invoke\_arn) | ARN to be used for invoking Lambda Function from API Gateway |
| <a name="output_function_role_arn"></a> [function\_role\_arn](#output\_function\_role\_arn) | ARN for the IAM role attached to the Lambda Fnction |
| <a name="output_function_version"></a> [function\_version](#output\_function\_version) | Latest published version of the Lambda Function |
