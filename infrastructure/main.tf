provider "aws" {
  region = "us-east-2"
}

module "api-gateway" {
  source = "./modules/api-gateway"

  imageFunct_lambda_arn = module.lambda.imageFunct_lambda_arn
  contactsFunct_lambda_arn = module.lambda.contactsFunct_lambda_arn
  imageFunct_lambda_name = module.lambda.imageFunct_lambda_name
  contactsFunct_lambda_name = module.lambda.contactsFunct_lambda_name
  cloudfront_distribution_url = module.cloudfront.cloudfront_distribution_url
}

module "s3" {
  source = "./modules/s3"

  # cloudfront_distribution_url = module.cloudfront.cloudfront_distribution_url
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

  frontend_bucket_arn = module.s3.frontend_bucket_arn
  frontend_bucket_id = module.s3.frontend_bucket_id
  cloudfront_oai_arn = module.cloudfront.cloudfront_oai_arn
}

module "codebuild" {
  source = "./modules/codebuild"

  codebuildRole_arn = module.iam.codebuildRole_arn
  codebuildRole_name = module.iam.codebuildRole_name
}

module "cloudfront" {
  source = "./modules/cloudfront"

  frontend_regional_domain_name = module.s3.frontend_regional_domain_name
}