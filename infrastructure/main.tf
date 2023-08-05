provider "aws" {
  region = "us-east-2"
}

module "api-gateway" {
  source = "./modules/api-gateway"

  imageFunct_lambda_arn = module.lambda.imageFunct_lambda_arn
  contactsFunct_lambda_arn = module.lambda.contactsFunct_lambda_arn
  imageFunct_lambda_name = module.lambda.imageFunct_lambda_name
  contactsFunct_lambda_name = module.lambda.contactsFunct_lambda_name
}

module "s3" {
  source = "./modules/s3"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "lambda" {
  source = "./modules/lambda"

  imageLambdaRole_arn = module.iam.imageLambdaRole_arn
  contactsLambdaRole_arn = module.iam.contactsLambdaRole_arn
  imageLambdaRole_name = module.iam.imageLambdaRole_name
  contactsLambdaRole_name = module.iam.contactsLambdaRole_name
  api_gateway_access_policy_arn = module.iam.api_gateway_access_policy_arn
  image_bucket_arn = module.s3.imageBucket_arn
  image_bucket_id = module.s3.imageBucket_id
  cay_api_gateway_execution_arn = module.api-gateway.cay_api_gateway_execution_arn
}

module "iam" {
  source = "./modules/iam"
}