// IAM policy document for api-gateway access
data "aws_iam_policy_document" "api_gateway_access" {
  statement {
    effect = "Allow"

    actions = [
      "apigateway:*",
    ]

    resources = [
      "*",
    ]
  }
}

// IAM policy resource for api-gateway access
resource "aws_iam_policy" "api_gateway_access_policy" {
  name        = "ApiGatewayAccessPolicy"
  description = "IAM policy for giving access to API Gateway"
  policy      = data.aws_iam_policy_document.api_gateway_access.json
}

// IAM role for contactsFunct Lambda
resource "aws_iam_role" "contactsLambdaRole" {
  name = "contactsLambdaRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

// IAM role for imageFunct Lambda
resource "aws_iam_role" "imageLambdaRole" {
  name = "imageLambdaRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}