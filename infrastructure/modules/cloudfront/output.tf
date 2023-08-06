output "cloudfront_distribution_url" {
  value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
  description = "The CloudFront distribution URL for the React App."
}
