resource "aws_lambda_function" "lambda-api" {
  function_name = "todos-api-tf-stack-${var.stage}"
  role          = aws_iam_role.lambda-role.arn

  runtime          = "nodejs16.x"
  handler          = "lambda.handler"
  filename         = "../backend/dist/lambda.zip"
  source_code_hash = filebase64sha256("../backend/dist/lambda.zip")

  environment {
    variables = {
      FRONTEND_URL = "https://${aws_cloudfront_distribution.todos.domain_name}"
      TODO_TABLE   = aws_dynamodb_table.todo.name
    }
  }

  tracing_config {
    mode = "Active"
  }
}

resource "aws_lambda_permission" "lambda-api" {
  function_name = aws_lambda_function.lambda-api.function_name
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.todos-api.execution_arn}/*/*/{proxy+}"
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
