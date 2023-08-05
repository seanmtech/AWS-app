variable "imageLambdaRole_arn" {
  description = "The ARN of the IAM Role for the image Lambda function"
  type        = string
}

variable "imageLambdaRole_name" {
  description = "The name of the IAM Role for the image Lambda function"
  type        = string
}

variable "contactsLambdaRole_arn" {
  description = "The ARN of the IAM Role for the contacts Lambda function"
  type        = string
}

variable "contactsLambdaRole_name" {
  description = "The name of the IAM Role for the contacts Lambda function"
  type        = string
}

variable "api_gateway_access_policy_arn" {
  description = "The ARN of the API Gateway Access Policy"
  type        = string
}

variable "image_bucket_arn" {
  description = "The ARN of the image bucket"
  type        = string
}

variable "image_bucket_id" {
  description = "The ID of the image bucket"
  type        = string
}

variable "cay_api_gateway_execution_arn" {
  description = "The ARN of the API Gateway Execution Role"
  type        = string
}