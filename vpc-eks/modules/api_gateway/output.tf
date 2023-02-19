output "api-gateway-arn" {
  value = aws_api_gateway_rest_api.api-gateway.execution_arn
}

output "api-id" {
  value = aws_api_gateway_rest_api.api-gateway.id
}