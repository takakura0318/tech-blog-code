// EventBridge Scheduler
resource "aws_iam_policy_attachment" "rds_start_stop_base" {
  name       = "rds-start-stop-base-policy-attachment"
  policy_arn = aws_iam_policy.rds_start_stop_base.arn
  groups     = []
  users      = []
  roles      = [aws_iam_role.eventbridge-scheduler-rds-start-stop-role.name]
}