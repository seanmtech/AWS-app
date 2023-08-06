variable "imageFunct_lambda_arn" {
  description = "The ARN of the imageFunct Lambda"
  type        = string
}

variable "contactsFunct_lambda_arn" {
  description = "The ARN of the contactsFunct Lambda"
  type        = string
}

variable "imageFunct_lambda_name" {
  description = "The name of the imageFunct Lambda"
  type        = string
}

variable "contactsFunct_lambda_name" {
  description = "The name of the contactsFunct Lambda"
  type        = string
}

variable "cloudfront_distribution_url" {
  description = "The URL of the CloudFront distribution"
  type        = string
}