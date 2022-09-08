resource "aws_dynamodb_table" "todo" {
  name           = "todo-tf-stack-${var.stage}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "toto" {
  table_name = aws_dynamodb_table.todo.name
  hash_key   = aws_dynamodb_table.todo.hash_key

  item = <<ITEM
{
  "id": { "S": "toto" },
  "done": { "BOOL": true },
  "name": { "S": "Toto" }
}
ITEM
}

resource "aws_dynamodb_table_item" "tata" {
  table_name = aws_dynamodb_table.todo.name
  hash_key   = aws_dynamodb_table.todo.hash_key

  item = <<ITEM
{
  "id": { "S": "tata" },
  "done": { "BOOL": true },
  "name": { "S": "Tata" }
}
ITEM
}

resource "aws_dynamodb_table_item" "tutu" {
  table_name = aws_dynamodb_table.todo.name
  hash_key   = aws_dynamodb_table.todo.hash_key

  item = <<ITEM
{
  "id": { "S": "tutu" },
  "done": { "BOOL": true },
  "name": { "S": "Tutu" }
}
ITEM
}

resource "aws_dynamodb_table_item" "terraform-stack" {
  table_name = aws_dynamodb_table.todo.name
  hash_key   = aws_dynamodb_table.todo.hash_key

  item = <<ITEM
{
  "id": { "S": "terraform-stack" },
  "done": { "BOOL": true },
  "name": { "S": "Terraform stack" }
}
ITEM
}

resource "aws_dynamodb_table_item" "cdk-stack" {
  table_name = aws_dynamodb_table.todo.name
  hash_key   = aws_dynamodb_table.todo.hash_key

  item = <<ITEM
{
  "id": { "S": "cdk-stack" },
  "done": { "BOOL": false },
  "name": { "S": "CDK stack" }
}
ITEM
}
