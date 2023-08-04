locals {
  paths = [
    {
      name    = "contact"
      parent  = null
      methods = ["OPTIONS", "POST"]
    },
    {
      name    = "{id}"
      parent  = "contact"
      methods = ["OPTIONS", "GET", "PUT", "DELETE"]
    },
    {
      name    = "contacts"
      parent  = null
      methods = ["OPTIONS", "GET"]
    },
    {
      name    = "health"
      parent  = null
      methods = ["OPTIONS", "GET"]
    },
    {
      name    = "addImage"
      parent  = null
      methods = ["OPTIONS", "POST"]
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

resource "aws_api_gateway_resource" "path" {
  for_each = { for path in local.paths : path.name => path }

  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  parent_id   = each.value.name == "{id}" ? aws_api_gateway_resource.path["contact"].id : (each.value.parent != null 
                      ? aws_api_gateway_resource.path[each.value.parent].id 
                      : aws_api_gateway_rest_api.cay_api_gateway.root_resource_id)
  path_part   = each.value.name
}


resource "aws_api_gateway_method" "method" {
  for_each = {
    for pm in local.path_methods : "${pm.name}_${pm.method}" => pm
  }

  rest_api_id   = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id   = aws_api_gateway_resource.path[each.value.name].id
  http_method   = each.value.method
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

# Define integration responses for the OPTIONS methods (CORS preflight)
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

# Define method responses for the actual methods
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

# Define integration responses for the actual methods
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




// these were in the wrong file, making sure they line up correctly with this one

resource "aws_api_gateway_integration" "contact_post" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path["contact"].id
  http_method = aws_api_gateway_method.method["contact_POST"].http_method
  
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.contactsFunct_lambda_arn
}

resource "aws_api_gateway_integration" "contact_id_get" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path["{id}"].id
  http_method = aws_api_gateway_method.method["{id}_GET"].http_method
  
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = var.contactsFunct_lambda_arn
}

resource "aws_api_gateway_integration" "contact_id_put" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path["{id}"].id
  http_method = aws_api_gateway_method.method["{id}_PUT"].http_method
  
  integration_http_method = "PUT"
  type                    = "AWS_PROXY"
  uri                     = var.contactsFunct_lambda_arn
}

resource "aws_api_gateway_integration" "contact_id_delete" {
  rest_api_id = aws_api_gateway_rest_api.cay_api_gateway.id
  resource_id = aws_api_gateway_resource.path["{id}"].id
  http_method = aws_api_gateway_method.method["{id}_DELETE"].http_method
  
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