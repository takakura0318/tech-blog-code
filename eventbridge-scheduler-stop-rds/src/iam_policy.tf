// RDSの起動・停止するポリシー
resource "aws_iam_policy" "rds_start_stop_base" {
  name = "rds-start-stop-policy"
  path = "/service-role/"
  description = "start and stop RDS clusters"
  policy = data.aws_iam_policy_document.rds_start_stop_base_policy.json
}

data "aws_iam_policy_document" "rds_start_stop_base_policy" {
  statement {
    effect = "Allow"
    actions = [
      "rds:StartDBCluster",
      "rds:StopDBCluster"
    ]
    // "arn:aws:rds:{リージョン名}:{アカウントID}:cluster:{クラスターID}"
    resources = [
      "arn:aws:rds:us-east-2:${data.aws_caller_identity.self.account_id}:cluster:${aws_rds_cluster.default.cluster_identifier}"
    ]
  }
}