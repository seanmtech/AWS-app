provider "aws" {
  region = "us-east-2"
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
}

module "iam" {
  source = "./modules/iam"
}