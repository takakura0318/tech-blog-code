// EventBridge Schedulerにアタッチする
// RDSの起動・停止するIAMロール
resource "aws_iam_role" "eventbridge-scheduler-rds-start-stop-role" {
  name = "eventbridge-scheduler-rds-start-stop-role"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "scheduler.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}