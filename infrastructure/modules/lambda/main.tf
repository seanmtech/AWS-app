// Lambda resource for image processing
resource "aws_lambda_function" "imageFunct" {
  function_name = "imageFunct"

  filename         = "imageFunct_payload.zip"
  source_code_hash = filebase64sha256("imageFunct_payload.zip")
  handler          = "index.handler"

  runtime = "nodejs16.x"

  role = var.imageLambdaRole_arn
}

// Lambda resource for contacts processing
resource "aws_lambda_function" "contactsFunct" {
  function_name = "contactsFunct"

  filename         = "contactsFunct_payload.zip"
  source_code_hash = filebase64sha256("contactsFunct_payload.zip")
  handler = "index.handler"

  runtime = "nodejs16.x"

  role = var.contactsLambdaRole_arn
}

// Permissions declared below
resource "aws_lambda_permission" "imageFunct" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.imageFunct.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.image_bucket_arn
}

// s3 bucket notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.image_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.imageFunct.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.imageFunct]
}

// IAM Role Attachments
resource "aws_iam_role_policy_attachment" "imageLambdaRole-attach" {
  role       = var.imageLambdaRole_name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "imageLambda-dynamodb-full-access" {
  role       = var.imageLambdaRole_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "contactsLambdaRole-attach" {
  role       = var.contactsLambdaRole_name  
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "contacts_lambda_api_gateway_access" {
  role       = var.contactsLambdaRole_name
  policy_arn = var.api_gateway_access_policy_arn
}

resource "aws_iam_role_policy_attachment" "contactsLambda-dynamodb-full-access" {
  role       = var.contactsLambdaRole_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}