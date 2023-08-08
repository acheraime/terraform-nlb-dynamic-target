
# Role policy document
data "aws_iam_policy_document" "this" {
    statement {
        sid = "AllowAsume"
        actions = [
            "sts:AssumeRole"
        ]
        effect = "Allow"
        principals {
          type = "Service"
          identifiers = ["lambda.amazonaws.com"]
        }
    }
}

# IAM role for the lambda function
resource "aws_iam_role" "this" {
    name = "nlb-target-role"
    assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
    role = aws_iam_role.this.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}