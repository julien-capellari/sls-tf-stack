resource "aws_apigatewayv2_api" "todos-api" {
  name          = "todos-api-tf-stack-${var.stage}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["https://${aws_cloudfront_distribution.todos.domain_name}"]
  }
}

resource "aws_apigatewayv2_integration" "todos-lambda-api" {
  api_id           = aws_apigatewayv2_api.todos-api.id
  integration_type = "AWS_PROXY"

  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.lambda-api.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "todos-lambda-api" {
  api_id    = aws_apigatewayv2_api.todos-api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.todos-lambda-api.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  name        = "$default"
  api_id      = aws_apigatewayv2_api.todos-api.id
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.todos-api.arn
    format          = jsonencode(
      {
        httpMethod     = "$context.httpMethod"
        ip             = "$context.identity.sourceIp"
        protocol       = "$context.protocol"
        requestId      = "$context.requestId"
        requestTime    = "$context.requestTime"
        responseLength = "$context.responseLength"
        routeKey       = "$context.routeKey"
        status         = "$context.status"
      }
    )
  }
}

output "api_url" {
  value = aws_apigatewayv2_api.todos-api.api_endpoint
}
