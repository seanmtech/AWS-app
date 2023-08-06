output "imageBucket_arn" {
  description = "The ARN of the S3 bucket"
  value = aws_s3_bucket.caylent-image-bucket1.arn
}

output "imageBucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.caylent-image-bucket1.id
}

output "frontend_regional_domain_name" {
  value       = aws_s3_bucket.cay-frontend-bucket.bucket_regional_domain_name
  description = "The regional domain name of the S3 bucket"
}

output "frontend_bucket_arn" {
  value       = aws_s3_bucket.cay-frontend-bucket.arn
  description = "The ARN of the S3 bucket"
}

output "frontend_bucket_id" {
  value       = aws_s3_bucket.cay-frontend-bucket.id
  description = "The ID of the S3 bucket"
}