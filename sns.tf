# Create SNS topic
resource "aws_sns_topic" "this" {
    name = "database-topic"
}

resource "aws_db_event_subscription" "this" {
    name = "database-topic-subscription"
    sns_topic = aws_sns_topic.this.arn

    source_type = "db-instance"
    source_ids = var.db_instance_ids

    event_categories = [
        "availability",
        "failover",
        "failure",
        "maintenance",
        "recovery",
        "restoration",
    ]
}

resource "aws_sns_topic_subscription" "this" {
    topic_arn = aws_sns_topic.this.arn
    protocol = "lambda"
    endpoint = aws_lambda_function.this.arn
}