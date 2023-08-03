// S3 bucket for images
resource "aws_s3_bucket" "caylent-image-bucket1" {
  bucket = "caylent-image-bucket1"

  tags = {
    Name        = "caylent-image-bucket1"
    Environment = "Dev"
  }
}

// block public access to image s3 bucket
resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.caylent-image-bucket1.id

  block_public_acls   = true
  block_public_policy = true
}