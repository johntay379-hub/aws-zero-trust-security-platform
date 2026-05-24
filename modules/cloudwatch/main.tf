resource "aws_sns_topic" "alerts" {
  name = "${var.project}-alerts"
  tags = { Name = "${var.project}-alerts" }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project}-cpu-high"
  alarm_description   = "Scale up — CPU above 70% for 5 minutes"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = 70
  comparison_operator = "GreaterThanThreshold"

  dimensions = { AutoScalingGroupName = var.asg_name }

  alarm_actions = [var.scale_up_arn, aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.project}-cpu-low"
  alarm_description   = "Scale down — CPU below 30% for 10 minutes"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 30
  comparison_operator = "LessThanThreshold"

  dimensions = { AutoScalingGroupName = var.asg_name }

  alarm_actions = [var.scale_down_arn, aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project}-alb-5xx-errors"
  alarm_description   = "ALERT: ALB is returning 5XX errors"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 10
  comparison_operator = "GreaterThanThreshold"

  dimensions = { LoadBalancer = var.alb_arn_suffix }

  alarm_actions     = [aws_sns_topic.alerts.arn]
  treat_missing_data = "notBreaching"
}
