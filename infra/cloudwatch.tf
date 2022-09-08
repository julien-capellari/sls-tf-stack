resource "aws_cloudwatch_log_group" "todos-api" {
  name = "/aws/apigateway/todos-api-tf-stack-${var.stage}"
}
