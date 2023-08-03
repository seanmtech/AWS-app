output "imageFunct_lambda_arn" {
  description = "The ARN of the imageFunct Lambda"
  value       = aws_lambda_function.imageFunct.arn
}

output "contactsFunct_lambda_arn" {
  description = "The ARN of the contactsFunct Lambda"
  value       = aws_lambda_function.contactsFunct.arn
}