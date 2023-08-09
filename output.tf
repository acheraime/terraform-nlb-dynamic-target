output "bucket_arn" {
    description = "ARN of the bucket where lambda codes are located at"
    value = data.aws_s3_bucket.bucket.arn
}