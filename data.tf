# Archive source folder
data "archive_file" "source" {
    type = "zip"
    source_dir = "${path.module}/lambda"
    output_path = "${path.module}/lambda/nlb-target.zip"
}

# Bucket lookup
data "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name
}