variable "bucket_name" {
    type = string
    description = "Name of the S3 bucket to upload lambda code"
    default = "zmn-lambda-dev"
}

variable "db_instance_ids" {
    type = list(string)
    description = "List of RDS instances ID"
}

variable "lb_target_group_arn" {
    type = string
    description = "ARN of the load balancer target group resource"
}

variable "rds_host_fqdn" {
    type = string
    description = "Fully qualified domain name of the RDS instance"
}

variable "lambda_log_level" {
    type = string
    description = "Log verbosity level of the lambda function"
    default = "info"
}

variable "max_retries" {
    type = number
    description = "Maximum times to retry a failed remote call"
    default = 3
}

variable "retry_interval_seconds" {
    type = number
    description = "Interval time in seconds to wait before retry a failed remote call"
    default = 5
}