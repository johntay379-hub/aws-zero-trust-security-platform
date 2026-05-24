data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_launch_template" "main" {
  name_prefix   = "${var.project}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.ec2_sg_id]
  }

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

        user_data = "IyEvYmluL2Jhc2gKeXVtIHVwZGF0ZSAteQp5dW0gaW5zdGFsbCAteSBodHRwZApzeXN0ZW1jdGwgZW5hYmxlIGh0dHBkCnN5c3RlbWN0bCBzdGFydCBodHRwZApjYXQgPiAvdmFyL3d3dy9odG1sL2luZGV4Lmh0bWwgPDwgJ0hUTUxFT0YnCjwhRE9DVFlQRSBodG1sPgo8aHRtbCBsYW5nPSJlbiI+CjxoZWFkPgogIDxtZXRhIGNoYXJzZXQ9IlVURi04Ij4KICA8dGl0bGU+WmVybyBUcnVzdCBTZWN1cml0eSBQbGF0Zm9ybTwvdGl0bGU+CiAgPHN0eWxlPgogICAgKnttYXJnaW46MDtwYWRkaW5nOjA7Ym94LXNpemluZzpib3JkZXItYm94fQogICAgYm9keXtmb250LWZhbWlseTptb25vc3BhY2U7YmFja2dyb3VuZDojMDMwNzEyO2NvbG9yOiNmMWY1Zjk7bWluLWhlaWdodDoxMDB2aDtkaXNwbGF5OmZsZXg7YWxpZ24taXRlbXM6Y2VudGVyO2p1c3RpZnktY29udGVudDpjZW50ZXJ9CiAgICAud3JhcHttYXgtd2lkdGg6NzAwcHg7cGFkZGluZzo0MHB4O2JvcmRlcjoxcHggc29saWQgcmdiYSg5OSwxNzksMjU1LDAuMik7Ym9yZGVyLXJhZGl1czoyMHB4O2JhY2tncm91bmQ6IzBkMTMyMX0KICAgIC5iYWRnZXtkaXNwbGF5OmlubGluZS1mbGV4O2FsaWduLWl0ZW1zOmNlbnRlcjtnYXA6OHB4O2JhY2tncm91bmQ6cmdiYSg1OSwxMzAsMjQ2LDAuMSk7Ym9yZGVyOjFweCBzb2xpZCByZ2JhKDU5LDEzMCwyNDYsMC4zKTtib3JkZXItcmFkaXVzOjEwMHB4O3BhZGRpbmc6NXB4IDE2cHg7Zm9udC1zaXplOjExcHg7Y29sb3I6IzkzYzVmZDtsZXR0ZXItc3BhY2luZzowLjFlbTttYXJnaW4tYm90dG9tOjI0cHh9CiAgICAuZG90e3dpZHRoOjZweDtoZWlnaHQ6NnB4O2JvcmRlci1yYWRpdXM6NTAlO2JhY2tncm91bmQ6IzIyYzU1ZTtib3gtc2hhZG93OjAgMCA4cHggIzIyYzU1ZTthbmltYXRpb246cHVsc2UgMnMgaW5maW5pdGV9CiAgICBAa2V5ZnJhbWVzIHB1bHNlezAlLDEwMCV7b3BhY2l0eToxfTUwJXtvcGFjaXR5OjAuM319CiAgICBoMXtmb250LXNpemU6MnJlbTtmb250LXdlaWdodDo3MDA7bWFyZ2luLWJvdHRvbTo4cHg7YmFja2dyb3VuZDpsaW5lYXItZ3JhZGllbnQoMTM1ZGVnLCM2MGE1ZmEsI2E3OGJmYSwjMzRkMzk5KTstd2Via2l0LWJhY2tncm91bmQtY2xpcDp0ZXh0Oy13ZWJraXQtdGV4dC1maWxsLWNvbG9yOnRyYW5zcGFyZW50O2JhY2tncm91bmQtY2xpcDp0ZXh0fQogICAgLnN1Yntjb2xvcjojOTRhM2I4O21hcmdpbi1ib3R0b206MzJweDtmb250LXNpemU6MC45cmVtfQogICAgLml0ZW17cGFkZGluZzoxMnB4IDA7Ym9yZGVyLWJvdHRvbToxcHggc29saWQgcmdiYSg5OSwxNzksMjU1LDAuMDgpO2Rpc3BsYXk6ZmxleDthbGlnbi1pdGVtczpjZW50ZXI7Z2FwOjEycHg7Zm9udC1zaXplOjE0cHh9CiAgICAuY2hlY2t7Y29sb3I6IzIyYzU1ZX0KICAgIC5mb290ZXJ7bWFyZ2luLXRvcDoyOHB4O2NvbG9yOiM0NzU1Njk7Zm9udC1zaXplOjExcHh9CiAgPC9zdHlsZT4KPC9oZWFkPgo8Ym9keT4KPGRpdiBjbGFzcz0id3JhcCI+CiAgPGRpdiBjbGFzcz0iYmFkZ2UiPjxkaXYgY2xhc3M9ImRvdCI+PC9kaXY+QUxMIFNZU1RFTVMgT1BFUkFUSU9OQUw8L2Rpdj4KICA8aDE+WmVybyBUcnVzdCBTZWN1cml0eSBQbGF0Zm9ybTwvaDE+CiAgPHAgY2xhc3M9InN1YiI+QXV0by1TY2FsZWQgwrcgTG9hZCBCYWxhbmNlZCDCtyBDb21wbGlhbmNlIFJlYWR5IMK3IEJ1aWx0IHdpdGggVGVycmFmb3JtPC9wPgogIDxkaXYgY2xhc3M9Iml0ZW0iPjxzcGFuIGNsYXNzPSJjaGVjayI+4pyFPC9zcGFuPiBJQU0g4oCUIExlYXN0IFByaXZpbGVnZSBFbmZvcmNlZDwvZGl2PgogIDxkaXYgY2xhc3M9Iml0ZW0iPjxzcGFuIGNsYXNzPSJjaGVjayI+4pyFPC9zcGFuPiBTMyDigJQgRW5jcnlwdGVkIEF1ZGl0IFZhdWx0IEFjdGl2ZTwvZGl2PgogIDxkaXYgY2xhc3M9Iml0ZW0iPjxzcGFuIGNsYXNzPSJjaGVjayI+4pyFPC9zcGFuPiBDbG91ZFRyYWlsIOKAlCBBbGwgQVBJIEV2ZW50cyBMb2dnZWQ8L2Rpdj4KICA8ZGl2IGNsYXNzPSJpdGVtIj48c3BhbiBjbGFzcz0iY2hlY2siPuKchTwvc3Bhbj4gVlBDIOKAlCBOZXR3b3JrIElzb2xhdGVkICYgU2VjdXJlZDwvZGl2PgogIDxkaXYgY2xhc3M9Iml0ZW0iPjxzcGFuIGNsYXNzPSJjaGVjayI+4pyFPC9zcGFuPiBBTEIg4oCUIFRyYWZmaWMgTG9hZCBCYWxhbmNlZDwvZGl2PgogIDxkaXYgY2xhc3M9Iml0ZW0iPjxzcGFuIGNsYXNzPSJjaGVjayI+4pyFPC9zcGFuPiBBU0cg4oCUIEF1dG8gU2NhbGluZyBBY3RpdmU8L2Rpdj4KICA8ZGl2IGNsYXNzPSJpdGVtIj48c3BhbiBjbGFzcz0iY2hlY2siPuKchTwvc3Bhbj4gQ2xvdWRXYXRjaCArIFNOUyDigJQgTW9uaXRvcmluZyBBY3RpdmU8L2Rpdj4KICA8ZGl2IGNsYXNzPSJpdGVtIj48c3BhbiBjbGFzcz0iY2hlY2siPuKchTwvc3Bhbj4gQVdTIENvbmZpZyDigJQgQ29tcGxpYW5jZSBWZXJpZmllZDwvZGl2PgogIDxkaXYgY2xhc3M9ImZvb3RlciI+QnVpbHQgYnkgSm9obiDCtyBUZXJyYWZvcm0gwrcgUmVnaW9uOiB1cy1lYXN0LTEgwrcgTWF5IDIwMjY8L2Rpdj4KPC9kaXY+CjwvYm9keT4KPC9odG1sPgpIVE1MRU9GCmNobW9kIDY0NCAvdmFyL3d3dy9odG1sL2luZGV4Lmh0bWwKc3lzdGVtY3RsIHJlc3RhcnQgaHR0cGQK"

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "${var.project}-web-server" }
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = "${var.project}-asg"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.public_subnet_ids
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}
