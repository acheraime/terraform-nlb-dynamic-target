variable "bucket_name" {
    type = string
    description = "Name of the S3 bucket to upload lambda code"
    default = "zmn-lambda-dev"
}

variable "db_instance_ids" {
    type = list(string)
    description = "List of RDS instances ID"
}

