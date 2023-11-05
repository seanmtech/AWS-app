// DynamoDB table for contacts
resource "aws_dynamodb_table" "AWSContactsApp" {
  name           = "AWSContactsApp"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id" # The attribute to use as the hash key.

  attribute {
    name = "id"
    type = "S" # The type of the attribute. N for number, S for string, B for binary.
  }

  # Enable DynamoDB point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name        = "AWSContactsApp"
    Environment = "Dev"
  }
}