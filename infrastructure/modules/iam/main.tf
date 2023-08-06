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

// CodeBuild section
  
  // Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "CodeBuildServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

  
  
  // policy for CodeBuild to access S3 bucket for frontend
    // TODO - integrate with CodeBuild later
resource "aws_iam_policy" "codebuild_s3_upload_policy" {
  name        = "CodeBuildS3UploadPolicy"
  description = "Allows CodeBuild to upload to the S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"],
        Effect   = "Allow",
        Resource = [var.frontend_bucket_arn, "${var.frontend_bucket_arn}/*"]
      }
    ]
  })
}

  // attach policy to CodeBuild role
resource "aws_iam_role_policy_attachment" "codebuild_s3_upload_attachment" {
  policy_arn = aws_iam_policy.codebuild_s3_upload_policy.arn
  role       = aws_iam_role.codebuild_role.name
}


// S3 bucket for static website roles
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cay-frontend-bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity YOUR_CLOUDFRONT_ORIGIN_ACCESS_IDENTITY"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.frontend_bucket_id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}
