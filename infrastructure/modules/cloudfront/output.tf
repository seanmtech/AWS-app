output "cloudfront_distribution_url" {
  value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
  description = "The CloudFront distribution URL for the React App."
}

output "cloudfront_oai" {
  value = aws_cloudfront_origin_access_identity.s3_front_end_OAI.cloudfront_access_identity_path
  description = "The CloudFront Origin Access Identity for the React App."
}

output "cloudfront_oai_arn" {
  value = aws_cloudfront_origin_access_identity.s3_front_end_OAI.iam_arn
  description = "The CloudFront Origin Access Identity ARN for the React App."
}