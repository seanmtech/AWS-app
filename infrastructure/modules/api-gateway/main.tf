locals {
  paths = [
    {
      name    = "contact"
      parent  = null
      methods = ["POST"]
    },
    {
      name    = "contacts"
      parent  = null
      methods = ["GET"]
    },
    {
      name    = "health"
      parent  = null
      methods = ["GET"]
    },
    {
      name    = "addImage"
      parent  = null
      methods = ["POST"]
    }
  ]

  path_methods = flatten([
    for path in local.paths : [
      for method in path.methods : {
        name   = path.name
        method = method
        parent = path.parent
      }
    ]
  ])
}

resource "aws_api_gateway_rest_api" "cay_api_gateway" {
  name        = "cay_api_gateway"
  description = "API Gateway for Caylent Practice app"
}

// use dynamic block to create resources for each path EXCEPT /contact/{id}
resource "aws_api_gateway_resource" "path" {
  for_each = { for path in local.paths : path.name => path }

  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.cay_api_gateway.root_resource_id
  path_part   = each.value.name
}

// use dynamic block to create resources for each path method EXCEPT /contact/{id}
resource "aws_api_gateway_method" "method" {
  for_each = {
    for pm in local.path_methods : "${pm.name}_${pm.method}" => pm
  }

  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.path[each.value.name].id
  http_method   = each.value.method
  authorization = "NONE"
}

// Declaring {id} resource and methods inidvidually as it was giving Terraform errors when trying in the dynamic block
resource "aws_api_gateway_resource" "id" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = aws_api_gateway_resource.path["contact"].id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "id_get" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.id.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_method" "id_put" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.id.id
  http_method   = "PUT"
  authorization = "NONE"
}
resource "aws_api_gateway_method" "id_delete" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.id.id
  http_method   = "DELETE"
  authorization = "NONE"
}
resource "aws_api_gateway_method" "id_options" {
  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}


# Add OPTIONS methods for each path to support CORS preflight
resource "aws_api_gateway_method" "options" {
  for_each = { for path in local.paths : path.name => path }

  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.path[each.key].id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# Define method responses for the OPTIONS methods (CORS preflight)
resource "aws_api_gateway_method_response" "preflight" {
  for_each = { for path in local.paths : path.name => path }

  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path[each.key].id
  http_method = aws_api_gateway_method.options[each.key].http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true,
  }
}
// create MOCK integrations for options methods (for dynamic block, NOT {id})
resource "aws_api_gateway_integration" "options" {
  for_each = { for path in local.paths : path.name => path }

  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path[each.key].id
  http_method = aws_api_gateway_method.options[each.key].http_method
  type        = "MOCK"
}

// create MOCK integrations for options methods (for {id})
resource "aws_api_gateway_integration" "contact_id_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.id_options.http_method
  type        = "MOCK"
}


# Define integration responses for the OPTIONS methods (CORS preflight) - for dynamic block, NOT {id}
resource "aws_api_gateway_integration_response" "preflight" {
  for_each = { for path in local.paths : path.name => path }

  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path[each.key].id
  http_method = aws_api_gateway_method.options[each.key].http_method
  status_code = aws_api_gateway_method_response.preflight[each.key].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,OPTIONS,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

// integration responses for the OPTIONS method for /contact/{id} (because it's not being made dynamically for now)
resource "aws_api_gateway_integration_response" "contact_id_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.id_options.http_method
  status_code = aws_api_gateway_method_response.contact_id_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,GET,OPTIONS,PUT,DELETE'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# Define method responses for the OPTIONS method for /contact/{id} (because it's not being made dynamically for now)
resource "aws_api_gateway_method_response" "contact_id_options_response" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.id_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true,
  }
}

# Define integration responses for the OPTIONS method for /contact/{id} (because it's not being made dynamically for now)


# Define method responses for the methods in local variable (not {id})
resource "aws_api_gateway_method_response" "actual" {
  for_each = {
    for pm in local.path_methods : "${pm.name}_${pm.method}" => pm
  }

  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path[each.value.name].id
  http_method = aws_api_gateway_method.method[each.key].http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# Define integration responses for the methods in local variable (not {id})
resource "aws_api_gateway_integration_response" "actual" {
  for_each = {
    for pm in local.path_methods : "${pm.name}_${pm.method}" => pm
  }

  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path[each.value.name].id
  http_method = aws_api_gateway_method.method[each.key].http_method
  status_code = aws_api_gateway_method_response.actual[each.key].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

// manually define method responses for {id} methods

resource "aws_api_gateway_method_response" "contact_id_get" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.id_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "contact_id_put" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.id_put.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "contact_id_delete" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.id_delete.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "contact_post" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path["contact"].id
  http_method = aws_api_gateway_method.method["contact_POST"].http_method
  
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.contactsFunct_lambda_arn
}
// manually define integration responses for {id} methods
resource "aws_api_gateway_integration" "contact_id_get" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.id_get.http_method
  
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = var.contactsFunct_lambda_arn
}

resource "aws_api_gateway_integration" "contact_id_put" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.id_put.http_method
  
  integration_http_method = "PUT"
  type                    = "AWS_PROXY"
  uri                     = var.contactsFunct_lambda_arn
}

resource "aws_api_gateway_integration" "contact_id_delete" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.id.id
  http_method = aws_api_gateway_method.id_delete.http_method
  
  integration_http_method = "DELETE"
  type                    = "AWS_PROXY"
  uri                     = var.contactsFunct_lambda_arn
}

resource "aws_api_gateway_integration" "contacts_get" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path["contacts"].id
  http_method = aws_api_gateway_method.method["contacts_GET"].http_method
  
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = var.contactsFunct_lambda_arn
}

resource "aws_api_gateway_integration" "addImage_post" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path["addImage"].id
  http_method = aws_api_gateway_method.method["addImage_POST"].http_method
  
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.imageFunct_lambda_arn
}

resource "aws_api_gateway_deployment" "cay_api_gateway_deployment" {
  depends_on  = [aws_api_gateway_method.method, aws_api_gateway_method.id_get, aws_api_gateway_method.id_put, aws_api_gateway_method.id_delete]
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  stage_name  = "prod"
}