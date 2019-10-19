resource "aws_api_gateway_rest_api" "api" {
  name        = "psa-ui-${var.swimlane}"
  description = "PSA UI"

  endpoint_configuration = {
    types = ["REGIONAL"]
  }

  binary_media_types = [
    "image/vnd.microsoft.icon",
    "image/png",
    "image/webp",
    "image/jxr",
    "text/html"
  ]
}

resource "aws_api_gateway_method" "frontend_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "frontend_root" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method = "${aws_api_gateway_method.frontend_root.http_method}"

  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_s3_bucket.frontend_website.bucket_regional_domain_name}/index.html"
}

resource "aws_api_gateway_resource" "frontend_public_root" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "public"
}

resource "aws_api_gateway_resource" "frontend_public" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_resource.frontend_public_root.id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "frontend_public" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.frontend_public.id}"
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "frontend_public" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.frontend_public.id}"
  http_method = "${aws_api_gateway_method.frontend_public.http_method}"

  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_s3_bucket.frontend_website.bucket_regional_domain_name}/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_resource" "frontend" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "frontend" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.frontend.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "frontend" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.frontend.id}"
  http_method = "${aws_api_gateway_method.frontend.http_method}"

  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "https://${aws_s3_bucket.frontend_website.bucket_regional_domain_name}/index.html"
}

resource "aws_api_gateway_resource" "api_root" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "api"
}

resource "aws_api_gateway_resource" "api" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_resource.api_root.id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.api.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.api.id}"
  http_method = "${aws_api_gateway_method.api.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.main.invoke_arn}"
}

resource "aws_api_gateway_resource" "graphql_root" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "graphql"
}

resource "aws_api_gateway_method" "graphql_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.graphql_root.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "graphql_root" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.graphql_root.id}"
  http_method = "${aws_api_gateway_method.graphql_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.main.invoke_arn}"
}

resource "aws_api_gateway_resource" "graphql" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_method.graphql_root.resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "graphql" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.graphql.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "graphql" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.graphql.id}"
  http_method = "${aws_api_gateway_method.graphql.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.main.invoke_arn}"
}

resource "aws_api_gateway_resource" "ws_root" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "ws"
}

resource "aws_api_gateway_resource" "ws" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_resource.ws_root.id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "ws" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.ws.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ws" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.ws.id}"
  http_method = "${aws_api_gateway_method.ws.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.main.invoke_arn}"
}

resource "aws_api_gateway_deployment" "preprod" {
  depends_on = [
    "aws_api_gateway_integration.frontend_root",
    "aws_api_gateway_integration.frontend",
    "aws_api_gateway_integration.frontend_public",
    "aws_api_gateway_integration.api",
    "aws_api_gateway_integration.graphql_root",
    "aws_api_gateway_integration.graphql",
    "aws_api_gateway_integration.ws",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "preprod"

  variables {
    deployed_at = "${timestamp()}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  deployment_id = "${aws_api_gateway_deployment.preprod.id}"

  tags {
    Module    = "${local.module}"
    Swimlane  = "${var.swimlane}"
    Version   = "${local.version}"
    ManagedBy = "${local.managed_by}"
  }
}

resource "aws_api_gateway_domain_name" "api-domain" {
  domain_name              = "${local.fqdn}"
  regional_certificate_arn = "${var.ssl_certificate_arn}"

  endpoint_configuration = {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "api-mapping" {
  api_id      = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${aws_api_gateway_stage.prod.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.api-domain.domain_name}"
}

resource "aws_api_gateway_method_settings" "log-settings" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${aws_api_gateway_stage.prod.stage_name}"
  method_path = "*/*"

   settings {
    logging_level = "ERROR"
  }
}