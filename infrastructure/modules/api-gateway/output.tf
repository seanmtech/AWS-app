output "cay_api_gateway_execution_arn" {
  description = "The execution ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.cay_api_gateway.execution_arn
}
