output "imageFunct_lambda_arn" {
  description = "The ARN of the imageFunct Lambda"
  value       = aws_lambda_function.imageFunct.arn
}

output "contactsFunct_lambda_arn" {
  description = "The ARN of the contactsFunct Lambda"
  value       = aws_lambda_function.contactsFunct.arn
}

output "imageFunct_lambda_name" {
  description = "The name of the imageFunct Lambda"
  value       = aws_lambda_function.imageFunct.function_name
}

output "contactsFunct_lambda_name" {
  description = "The name of the contactsFunct Lambda"
  value       = aws_lambda_function.contactsFunct.function_name
}