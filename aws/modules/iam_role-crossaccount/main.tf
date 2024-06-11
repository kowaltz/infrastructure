resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
  
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess",
    "arn:aws:iam::aws:policy/AWSSecurityTokenServiceFullAccess"
  ]
}

resource "aws_lambda_function" "create_iam_role" {
  filename         = "lambda_function_payload.zip"
  function_name    = "create_iam_role"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  runtime          = "python3.8"
}

resource "aws_lambda_permission" "allow_invoke" {
  statement_id  = "AllowExecutionFromTerraform"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_iam_role.function_name
  principal     = "terraform.amazonaws.com"
}

resource "aws_lambda_invocation" "invoke_create_iam_role" {
  function_name = aws_lambda_function.create_iam_role.function_name
  input         = jsonencode({
    TargetAccountId = var.aws_account_id_target,
    RoleName        = "ROLE_NAME",
    Organization    = "ORGANIZATION_NAME",
    Env             = "ENVIRONMENT",
    Name            = "NAME"
  })
}

resource "aws_cloudwatch_log_group" "lambda_log" {
  name              = "/aws/lambda/${aws_lambda_function.create_iam_role.function_name}"
  retention_in_days = 14
}
