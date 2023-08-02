provider "aws" {
  region = "us-west-2"
}

data "aws_iam_policy_document" "lambda_access" {
  statement {
    actions = [
      "s3:*",
      "dynamodb:*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_access_policy" {
  name = "lambda_access_policy"
  role = aws_iam_role.lambda_role.id

  policy = data.aws_iam_policy_document.lambda_access.json
}

resource "aws_lambda_function" "contacts_lambda" {
  function_name = "contacts-lambda-1.2"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler" # handler location in your source code
  runtime       = "nodejs12.x"

  filename = "contacts_lambda.zip" # replace with your .zip file

  source_code_hash = filebase64sha256("contacts_lambda.zip") # replace with your .zip file
}

resource "aws_lambda_function" "image_lambda" {
  function_name = "image-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler" # handler location in your source code
  runtime       = "nodejs12.x"

  filename = "image_lambda.zip" # replace with your .zip file

  source_code_hash = filebase64sha256("image_lambda.zip") # replace with your .zip file
}

resource "aws_apigatewayv2_api" "api" {
  name          = "api"
  protocol_type = "HTTP"
}

# define your API endpoints here
resource "aws_apigatewayv2_route" "route_contact" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "ANY /contact"
  target    = "integrations/${aws_apigatewayv2_integration.contacts_lambda.id}"
}

resource "aws_apigatewayv2_route" "route_contacts" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "ANY /contacts"
  target    = "integrations/${aws_apigatewayv2_integration.contacts_lambda.id}"
}

#... repeat for other routes

resource "aws_apigatewayv2_integration" "contacts_lambda" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  integration_uri = aws_lambda_function.contacts_lambda.invoke_arn
}

resource "aws_apigatewayv2_integration" "image_lambda" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  integration_uri = aws_lambda_function.image_lambda.invoke_arn
}

resource "aws_dynamodb_table" "Contacts2" {
  name           = "Contacts2"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "N"
  }
}

resource "aws_s3_bucket" "static_site" {
  bucket = "caylent-app-frontend1.2"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket" "image_bucket" {
  bucket = "imageBucket"
  acl    = "public-read-write"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.static_site.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.static_site.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.static_site.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for S3 bucket"
}

resource "aws_cognito_user_pool" "caylent_app_users" {
  name = "caylent-app-users"
}
