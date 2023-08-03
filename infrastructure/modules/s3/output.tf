output "imageBucket_arn" {
  description = "The ARN of the S3 bucket"
  value = aws_s3_bucket.caylent-image-bucket1.arn
}

output "imageBucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.caylent-image-bucket1.id
}