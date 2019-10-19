resource "aws_s3_bucket" "frontend_website" {
  bucket = "demo-${var.swimlane}"
  tags {
    Swimlane = "${var.swimlane}"
    Module   = "${local.module}"
    Version   = "${local.version}"
    ManagedBy = "${local.managed_by}"
  }
}