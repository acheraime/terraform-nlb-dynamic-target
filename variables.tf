variable "function_name" {
    type = string
    description = "Name of the Lambda Function."
    default = null
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
    validation {
        condition = can(regex("[debug|info|warning|error|critical]", var.lambda_log_level))
        error_message = "Not a valid log level."
    }
}

variable "max_retries" {
    type = number
    description = "Maximum times to retry a failed remote call within the range [1-10]"
    default = 3
    validation {
        condition = (
            var.max_retries >= 1 && var.max_retries <= 10
        )
        error_message = "We expect max_retries value to be a positive number between 1 - 10."
    }
}

variable "retry_interval_seconds" {
    type = number
    description = "Interval time in seconds to wait before retry a failed remote call"
    default = 5
    validation {
        condition = (
            var.retry_interval_seconds >= 5 && var.retry_interval_seconds <= 1800
        )
        error_message = "The retry interval in seconds must be between 5 and 1800."
    }
}