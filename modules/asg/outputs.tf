output "asg_name"        { value = aws_autoscaling_group.main.name }
output "scale_up_arn"   { value = aws_autoscaling_policy.scale_up.arn }
output "scale_down_arn" { value = aws_autoscaling_policy.scale_down.arn }
