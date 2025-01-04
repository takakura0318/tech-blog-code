//////////////////////////////////////////////////
// EventBridgeScheduler
// Aurora クラスタを起動
//////////////////////////////////////////////////
resource "aws_scheduler_schedule" "aurora_start" {
  name       = "aurora-start"
  group_name = "default"
  flexible_time_window {
    // フレックスタイムウィンドウは使用しない
    mode = "OFF"
  }

  // 平日 (MON-FRI) の 8:00 に起動
  // cron(分 時 日 月 曜日 年) の順で指定
  // 年の指定は * にすることで毎年有効となる
  schedule_expression = "cron(0 8 ? * MON-FRI *)"
  schedule_expression_timezone = "Asia/Tokyo"

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:rds:startDBCluster"
    role_arn = aws_iam_role.eventbridge-scheduler-rds-start-stop-role.arn
    input = jsonencode({
      DbClusterIdentifier = aws_rds_cluster.default.cluster_identifier
    })

    retry_policy {
      maximum_event_age_in_seconds = 600 // リトライする最大のイベントの経過時間：10分
      maximum_retry_attempts       = 1   // リトライ最大回数
    }
  }
}

//////////////////////////////////////////////////
// EventBridgeScheduler
// Aurora クラスタを停止
//////////////////////////////////////////////////
resource "aws_scheduler_schedule" "aurora_stop" {
  name       = "aurora-stop"
  group_name = "default"
  flexible_time_window {
    // フレックスタイムウィンドウは使用しない
    mode = "OFF"
  }

  // 平日 (MON-FRI) の 21:00 に停止
  schedule_expression = "cron(0 21 ? * MON-FRI *)"
  schedule_expression_timezone = "Asia/Tokyo"

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:rds:stopDBCluster"
    role_arn = aws_iam_role.eventbridge-scheduler-rds-start-stop-role.arn
    input = jsonencode({
      DbClusterIdentifier = aws_rds_cluster.default.cluster_identifier
    })

    retry_policy {
      maximum_event_age_in_seconds = 600 // リトライする最大のイベントの経過時間：10分
      maximum_retry_attempts       = 1   // リトライ最大回数
    }
  }
}

// 動作確認用
// (定期的: 毎日 20:20 JST)
#resource "aws_scheduler_schedule" "aurora_stop" {
#  name       = "aurora-stop"
#  group_name = "default"
#  flexible_time_window {
#    mode = "OFF"
#  }
#
#  // 毎日 (day-of-week は問わない) 20:20 JST
#  // cron(Minute Hour Day-of-month Month Day-of-week Year)
#  // 日・月は「*」＝毎日、曜日は「?」としています。
#  schedule_expression = "cron(50 20 * * ? *)"
#  schedule_expression_timezone = "Asia/Tokyo"
#
#  target {
#    arn      = "arn:aws:scheduler:::aws-sdk:rds:stopDBCluster"
#    role_arn = aws_iam_role.eventbridge-scheduler-rds-start-stop-role.arn
#    input = jsonencode({
#      DbClusterIdentifier = aws_rds_cluster.default.cluster_identifier
#    })
#
#    retry_policy {
#      maximum_event_age_in_seconds = 600
#      maximum_retry_attempts       = 1
#    }
#  }
#}

