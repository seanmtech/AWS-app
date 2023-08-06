output "api_gateway_access_policy_arn" {
  description = "The ARN of the API Gateway Access Policy"
  value       = aws_iam_policy.api_gateway_access_policy.arn
}

output "contactsLambdaRole_arn" {
  description = "The ARN of the IAM role for the contacts processing Lambda function"
  value       = aws_iam_role.contactsLambdaRole.arn
}

output "imageLambdaRole_arn" {
  description = "The ARN of the IAM role for the image processing Lambda function"
  value       = aws_iam_role.imageLambdaRole.arn
}

output "contactsLambdaRole_name" {
  description = "The name of the IAM role for the contacts processing Lambda function"
  value       = aws_iam_role.contactsLambdaRole.name
}

output "imageLambdaRole_name" {
  description = "The name of the IAM role for the image processing Lambda function"
  value       = aws_iam_role.imageLambdaRole.name
}

output "codebuildRole_arn" {
  description = "The ARN of the IAM role for CodeBuild"
  value       = aws_iam_role.codebuild_role.arn
}

output "codebuildRole_name" {
  description = "The name of the IAM role for CodeBuild"
  value       = aws_iam_role.codebuild_role.name
}