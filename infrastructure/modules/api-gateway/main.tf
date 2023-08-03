resource "aws_api_gateway_rest_api" "cay_api_gateway" {
  name        = "cay_api_gateway"
  description = "API Gateway for Caylent Practice app"
}

// ROUTE and METHOD declarations
resource "aws_api_gateway_resource" "contact" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.cay_api_gateway.root_resource_id
  path_part   = "contact"
}

resource "aws_api_gateway_method" "contact_options" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.contact.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "contact_post" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.contact.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "contact_id" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = aws_api_gateway_resource.contact.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "contact_id_get" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.contact_id.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "contact_id_put" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.contact_id.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "contact_id_delete" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.contact_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "contact_id_options" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.contact_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "contacts" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.cay_api_gateway.root_resource_id
  path_part   = "contacts"
}

resource "aws_api_gateway_method" "contacts_get" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.contacts.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "contacts_options" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.contacts.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "health" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.cay_api_gateway.root_resource_id
  path_part   = "health"
}

resource "aws_api_gateway_method" "health_get" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.cay_api_gateway.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "health_options" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.cay_api_gateway.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "addImage" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.cay_api_gateway.root_resource_id
  path_part   = "addImage"
}

resource "aws_api_gateway_method" "addImage_post" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.cay_api_gateway.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "addImage_options" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.cay_api_gateway.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# CORS configuration
resource "aws_api_gateway_method_response" "contact_200_response" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.contact_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true,
  }
}

resource "aws_api_gateway_method_response" "contact_id_200_response" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.contact_id.id
  http_method = aws_api_gateway_method.contact_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true,
  }
}

# You'll need a similar configuration for every method in your API
resource "aws_api_gateway_integration" "contact_options" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.contact_options.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_integration" "contact_id_options" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.contact_id.id
  http_method = aws_api_gateway_method.contact_options.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_integration_response" "contact_options_response" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.contact.id
  http_method = aws_api_gateway_method.contact_options.http_method
  status_code = aws_api_gateway_method_response.contact_200_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "contact_id_options_response" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.contact_id.id
  http_method = aws_api_gateway_method.contact_options.http_method
  status_code = aws_api_gateway_method_response.contact_id_200_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}
