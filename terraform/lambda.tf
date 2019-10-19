resource "aws_lambda_function" "main" {
  function_name    = "companydemo-${var.swimlane}"
  filename         = "lambda.zip"
  source_code_hash = "${base64sha256(file("lambda.zip"))}"
  handler          = "lambda.handler"
  runtime          = "nodejs8.10"
  role             = "${aws_iam_role.lambda-role.arn}"
  timeout          = "${var.main_lambda_timeout}"
  memory_size      = "${var.main_lambda_memory_size}"

  environment {
    variables {
      NODE_ENV                          = "production"
      SENTRY_DSN                        = "${var.sentry_dsn}"
      API_GATEWAY_VPC_ENDPOINT_HOSTNAME = "${var.api_gateway_vpc_endpoint_hostname}"
      AF_SERVICE_HOST                   = "${var.af_service_host}"
      SWIMLANE                          = "${var.swimlane}"
      APPLICATION_NAME                  = "demo"
      TASK_ENHANCEMENT_TABLE_NAME       = "${aws_dynamodb_table.task-enhancement-history-table.id}"
      TASK_ENTRY_TABLE_NAME             = "${aws_dynamodb_table.task-entry-table.id}"
      TASK_ENTRY_INDEX_NAME             = "tenantSlug_timestamp_id_index"
      TASK_ENTRY_PROJECT_INDEX_NAME     = "projectUri_timestamp_id_index"
      TASK_ENTRY_ID_INDEX_NAME          = "taskEntryId_index"
      TASK_ENTRY_APPROVAL_INDEX_NAME    = "tenantSlug_approvalStatus_timestamp_index"
      TASK_ENTRY_OVERRIDE_TABLE_NAME    = "${aws_dynamodb_table.task-entry-override-table.id}"
      PROJECT_AGGREGATES_TABLE_NAME     = "${aws_dynamodb_table.project-aggregates-table.id}"
      PROJECT_REPORT_TABLE_NAME         = "${aws_dynamodb_table.project-report-table.id}"
      RESOURCE_REQUEST_TABLE_NAME       = "${aws_dynamodb_table.resource-request-table.id}"
      RESOURCE_REQUEST_INDEX_NAME       = "projectUri_requestedDate_index"
      RESOURCE_ALLOCATION_TABLE_NAME    = "${aws_dynamodb_table.resource-allocation-table.id}"
      RESOURCE_ALLOCATION_INDEX_NAME    = "resourceAllocation_projectUri_index"
      RESOURCING_TABLE_NAME             = "${aws_dynamodb_table.resourcing-table.id}"
      WEBSOCKET_DISPATCHER_URL          = "${var.websocket_dispatcher_service_url}"
      EVENT_INGRESS_TOPIC_ARN           = "${join("", aws_sns_topic.event_ingress.*.arn)}"
      WS_API_GATEWAY_ENDPOINT           = "${local.ws_fqdn}"
      MB_TOPIC_ARN                      = "${var.message_bus_topic_arn}"
    }
  }

  vpc_config {
    subnet_ids         = "${var.subnet_ids}"
    security_group_ids = ["${aws_security_group.security-group.id}"]
  }

  tags {
    Module    = "${local.module}"
    Swimlane  = "${var.swimlane}"
    Version   = "${local.version}"
    ManagedBy = "${local.managed_by}"
  }
}

resource "aws_iam_role" "lambda-role" {
  name                  = "demo-lambda-role-${var.swimlane}"
  force_detach_policies = true

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

resource "aws_iam_policy" "lambda-policy" {
  name = "demo-lambda-policy-${var.swimlane}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "execute-api:ManageConnections"
      ],
      "Resource": [
        "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${var.websocket_api_gateway_id}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": [
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.task-enhancement-history-table.id}",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.task-enhancement-history-table.id}/*",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.task-entry-table.id}",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.task-entry-table.id}/*",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.task-entry-override-table.id}",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.task-entry-override-table.id}/*",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.project-aggregates-table.id}",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.project-aggregates-table.id}/*",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.project-report-table.id}",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.project-report-table.id}/*",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.resource-request-table.id}",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.resource-request-table.id}/*",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.resource-allocation-table.id}",
        "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${aws_dynamodb_table.resource-allocation-table.id}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "sns:Publish"
      ],
      "Resource": [
        "${var.message_bus_topic_arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda-policy-attachment" {
  name       = "demo-lambda-${var.swimlane}-policy-attachment"
  roles      = ["${aws_iam_role.lambda-role.name}"]
  policy_arn = "${aws_iam_policy.lambda-policy.arn}"
}

resource "aws_lambda_permission" "apigateway_preprod" {
  statement_id  = "AllowAPIGatewayInvoke-preprod"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.main.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.preprod.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigateway_prod" {
  statement_id  = "AllowAPIGatewayInvoke-prod"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.main.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_stage.prod.execution_arn}/*/*"
}
