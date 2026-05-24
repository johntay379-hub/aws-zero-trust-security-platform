output "alb_dns_name" {
  description = "Load balancer DNS name — visit this in your browser"
  value       = module.alb.alb_dns_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "asg_name" {
  value = module.asg.asg_name
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "cloudtrail_arn" {
  value = module.cloudtrail.trail_arn
}

output "sns_topic_arn" {
  value = module.cloudwatch.sns_topic_arn
}
