resource "aws_dynamodb_table" "migration" {
  name           = "company-demo-${var.swimlane}-migrations"
  read_capacity  = "1"
  write_capacity = "1"
  hash_key       = "name"

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "name"
    type = "S"
  }
}

resource "aws_dynamodb_table" "task-enhancement-table" {
  name         = "company-demo-${var.swimlane}-task-enhancement"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "taskUri"

  attribute {
    name = "taskUri"
    type = "S"
  }

  tags {
    Name      = "company-demo-${var.swimlane}-task-enhancement"
    Swimlane  = "${var.swimlane}"
    Module    = "${local.module}"
    Version   = "${local.version}"
    ManagedBy = "${local.managed_by}"
  }
}

resource "aws_dynamodb_table" "task-enhancement-history-table" {
  name         = "company-demo-${var.swimlane}-task-enhancement-history"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "taskUri"
  range_key    = "effectiveTimestamp"

  attribute {
    name = "taskUri"
    type = "S"
  }

  attribute {
    name = "effectiveTimestamp"
    type = "S"
  }

  tags {
    Name      = "company-demo-${var.swimlane}-task-enhancement-history"
    Swimlane  = "${var.swimlane}"
    Module    = "${local.module}"
    Version   = "${local.version}"
    ManagedBy = "${local.managed_by}"
  }
}

resource "aws_dynamodb_table" "task-entry-table" {
  name             = "company-demo-${var.swimlane}-task-entry"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "taskUri"
  range_key        = "timestamp_id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "taskUri"
    type = "S"
  }

  attribute {
    name = "timestamp_id"
    type = "S"
  }

  attribute {
    name = "tenantSlug"
    type = "S"
  }

  attribute {
    name = "projectUri"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "approvalStatus_timestamp"
    type = "S"
  }

  global_secondary_index {
    name            = "tenantSlug_timestamp_id_index"
    hash_key        = "tenantSlug"
    range_key       = "timestamp_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "projectUri_timestamp_id_index"
    hash_key        = "projectUri"
    range_key       = "timestamp_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "taskEntryId_index"
    hash_key        = "id"
    projection_type = "KEYS_ONLY"
  }

  global_secondary_index {
    name            = "tenantSlug_approvalStatus_timestamp_index"
    hash_key        = "tenantSlug"
    range_key       = "approvalStatus_timestamp"
    projection_type = "ALL"
  }

  tags {
    Name      = "company-demo-${var.swimlane}-task-entry"
    Swimlane  = "${var.swimlane}"
    Module    = "${local.module}"
    Version   = "${local.version}"
    ManagedBy = "${local.managed_by}"
  }
}

resource "aws_dynamodb_table" "task-entry-override-table" {
  name             = "company-demo-${var.swimlane}-task-entry-override"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "taskEntryId"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "taskEntryId"
    type = "S"
  }

  tags {
    Name      = "company-demo-${var.swimlane}-task-entry-override"
    Swimlane  = "${var.swimlane}"
    Module    = "${local.module}"
    Version   = "${local.version}"
    ManagedBy = "${local.managed_by}"
  }
}

resource "aws_dynamodb_table" "project-aggregates-table" {
  name         = "company-demo-${var.swimlane}-project-aggregates"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "projectUri"

  attribute {
    name = "projectUri"
    type = "S"
  }

  tags {
    Name      = "company-demo-${var.swimlane}-project-aggregates"
    Swimlane  = "${var.swimlane}"
    Module    = "${local.module}"
    Version   = "${local.version}"
    ManagedBy = "${local.managed_by}"
  }
}

resource "aws_dynamodb_table" "project-report-table" {
  name         = "company-demo-${var.swimlane}-project-report"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "projectUri"
  range_key    = "dueDate"

  attribute {
    name = "projectUri"
    type = "S"
  }

  attribute {
    name = "dueDate"
    type = "S"
  }

  tags {
    Name      = "company-demo-${var.swimlane}-project-report"
    Swimlane  = "${var.swimlane}"
    Module    = "${local.module}"
    Version   = "${local.version}"
    ManagedBy = "${local.managed_by}"
  }
}

module "dynamodb-automated-backups" {
  source = "./dynamodb-automated-backups"

  backup_tables = [
    "${aws_dynamodb_table.task-entry-override-table.name}",
    "${aws_dynamodb_table.task-entry-table.name}",
    "${aws_dynamodb_table.task-enhancement-history-table.name}",
    "${aws_dynamodb_table.project-aggregates-table.name}",
    "${aws_dynamodb_table.project-report-table.name}",
    "${aws_dynamodb_table.resource-request-table.name}",
    "${aws_dynamodb_table.resource-allocation-table.name}",
    "${aws_dynamodb_table.resourcing-table.id}",
  ]

  swimlane                 = "${var.swimlane}"
  backup_retention_in_days = "${lookup(var.dynamodb_backups,"retention","30")}"
  log_level                = "${lookup(var.dynamodb_backups, "log_level", "info")}"
  backup_schedule          = "${lookup(var.dynamodb_backups,"schedule","rate(1 day)")}"
  notification_topic_arn   = "${var.health_alarm_topic_arn}"
}
