resource "aws_apigatewayv2_api" "todos-api" {
  name          = "todos-api-tf-stack-${var.stage}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["https://${aws_cloudfront_distribution.todos.domain_name}"]
  }
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
