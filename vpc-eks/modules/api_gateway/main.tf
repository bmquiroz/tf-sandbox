data "template_file" "aws-api-swagger" {
  template = file("swagger.yaml")

   # Pass the varible value if needed in Swagger file
  vars = {
    env           = var.env
    random_string = var.random_string
    account_id    = var.account_id
    cat_url       = var.cat_url
  }
}

resource "aws_api_gateway_authorizer" "api-auth" {
  name                   = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-atlas-api-auth")
  rest_api_id            = aws_api_gateway_rest_api.api-gateway.id
  authorizer_uri         = aws_lambda_function.lambda-authorizer.invoke_arn
}

resource "aws_api_gateway_rest_api" "api-gateway" {
  name        = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-atlas-api-gateway")
  description = "API gateway for Atlas APIs"
  body        = data.template_file.aws-api-swagger.rendered
}

resource "aws_iam_role" "lambda-role" {
  name = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-lambda-role")

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda-authorizer" {
  filename      = "atlas-authorizer-AtlasAuthorizerFunction-c4bozT6o58Jn-6d32eb1f-5839-44e5-8f19-17ebca14722f.zip"
  function_name = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-lambda-auth")
  role          = aws_iam_role.lambda-role.arn
  handler       = "exports.lambdaHandler"
  runtime       = "nodejs16.x"
  source_code_hash = filebase64sha256("atlas-authorizer-AtlasAuthorizerFunction-c4bozT6o58Jn-6d32eb1f-5839-44e5-8f19-17ebca14722f.zip")
}

# resource "aws_api_gateway_deployment" "atlas-api-gateway-deployment" {
#   depends_on  = [aws_api_gateway_rest_api.atlas-api-gateway]
#   rest_api_id = aws_api_gateway_rest_api.atlas-api-gateway.id
#   stage_name  = var.env
# }

resource "aws_api_gateway_deployment" "api-gateway-deployment" {
  depends_on  = [aws_api_gateway_rest_api.api-gateway]
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  stage_name  = var.env
}

resource "aws_api_gateway_vpc_link" "vpc-link" {
  name        = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-vpc-link")
  description = "API Gateway VPC link"
  target_arns = var.nlb_endpoint_arns
}