// S3 bucket for images
resource "aws_s3_bucket" "AWS-image-bucket1" {
  bucket = "AWS-image-bucket1"

  tags = {
    Name        = "AWS-image-bucket1"
    Environment = "Dev"
  }
}

// block public access to image s3 bucket
resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.AWS-image-bucket1.id

  block_public_acls   = true
  block_public_policy = true
}

// S3 bucket for static website
resource "aws_s3_bucket" "cay-frontend-bucket" {
  bucket = "cay-frontend-bucket"
  acl    = "private" 
  
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  tags = {
    Name        = "cay-frontend-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_website_configuration" "cay_frontend_website_config" {
  bucket = aws_s3_bucket.cay-frontend-bucket.bucket

  index_document {
    suffix = "index.html"
  }
}

// S3 bucket for CodePipeline artifacts
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "your-unique-codepipeline-bucket-name"
  acl    = "private"
}
