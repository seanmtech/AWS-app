provider "aws" {
  region = "us-east-2"
}

// Infrastructure
  // S3 bucket for images
resource "aws_s3_bucket" "caylent-image-bucket1" {
  bucket = "caylent-image-bucket1"

  tags = {
    Name        = "caylent-image-bucket1"
    Environment = "Dev"
  }
}
  // DynamoDB table for contacts
resource "aws_dynamodb_table" "CaylentContactsApp" {
  name           = "CaylentContactsApp"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id" # The attribute to use as the hash key.

  attribute {
    name = "id"
    type = "S" # The type of the attribute. N for number, S for string, B for binary.
  }

  # Enable DynamoDB point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name        = "CaylentContactsApp"
    Environment = "Dev"
  }
}

  // Lambda resource for image processing
resource "aws_lambda_function" "imageFunct" {
  function_name = "imageFunct"

  filename         = "imageFunct_payload.zip"
  source_code_hash = filebase64sha256("imageFunct_payload.zip")
  handler          = "index.handler"

  runtime = "nodejs16.x"

  role = aws_iam_role.imageLambdaRole.arn
}

// IAM Roles and Policies 
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

  // IAM policy for DynamoDB
resource "aws_iam_policy" "dynamodb_access" {
  name        = "dynamodb_access"
  description = "Policy to allow Lambda to access DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:*:*:table/CaylentContactsApp"
      },
    ]
  })
}

  // block public access to image s3 bucket
resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.caylent-image-bucket1.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.caylent-image-bucket1.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.imageFunct.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.imageFunct]
}

resource "aws_lambda_permission" "imageFunct" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.imageFunct.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.caylent-image-bucket1.arn
}

// role attachments
resource "aws_iam_role_policy_attachment" "imageLambdaRole-attach" {
  role       = aws_iam_role.imageLambdaRole.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "dynamodb-full-access" {
  role       = aws_iam_role.imageLambdaRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}