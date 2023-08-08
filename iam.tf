
# Role STS policy document
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

# Extra policies
data "aws_iam_policy_document" "extra" {
    statement {
        sid = "AllowCreateNetIfaces"
        actions = [
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:DescribeTargetHealth",
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
        ]
        effect = "Allow"
        resources = ["*"] #TODO: Too permissive, add only arns of target load  balancer
    }

    statement {
        sid = "AllowWriteLogs"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        effect = "Allow"
        resources = ["arn:aws:logs:*:*:*"]
    }
}

resource "aws_iam_policy" "extra" {
    name = "nlb-target-update-policy"
    policy = data.aws_iam_policy_document.extra.json
}

resource "aws_iam_role_policy_attachment" "extra" {
    role = aws_iam_role.this.name
    policy_arn = aws_iam_policy.extra.arn
}