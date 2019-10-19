resource "aws_elasticsearch_domain" "demo-elasticsearch" {
  domain_name           = "demo-${var.swimlane}-elasticsearch"
  elasticsearch_version = "6.3"

  encrypt_at_rest {
    enabled = true
  }

  cluster_config {
    instance_type          = "m4.large.elasticsearch"
    instance_count         = "${length(var.subnet_ids)}"
    zone_awareness_enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 100
    volume_type = "gp2"
  }

  vpc_options {
    subnet_ids         = "${var.subnet_ids}"
    security_group_ids = ["${aws_security_group.security-group.id}"]
  }

  access_policies = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${var.aws_region}:${var.aws_account_id}:domain/demo-${var.swimlane}-elasticsearch/*"
    }
  ]
}
EOF

  tags {
    Module    = "${local.module}"
    Swimlane  = "${var.swimlane}"
    Version   = "${local.version}"
    ManagedBy = "${local.managed_by}"
  }
}
