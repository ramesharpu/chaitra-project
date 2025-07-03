provider "aws" {
  region = "ap-south-1"
}

resource "aws_lambda_function" "appointment-service" {
  function_name = "appointment-service"
  filename      = "${path.module}/appointment-service.zip"
  source_code_hash = filebase64sha256("${path.module}/appointment-service.zip")
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "patient-service" {
  function_name = "patient-service"
  filename      = "${path.module}/patient-service.zip"
  source_code_hash = filebase64sha256("${path.module}/patient-service.zip")
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
