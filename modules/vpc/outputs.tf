output "vpc_id" { value = aws_vpc.main.id }
output "public_subnet_ids"  { value = [aws_subnet.public_1.id, aws_subnet.public_2.id] }
output "private_subnet_ids" { value = [aws_subnet.private_1.id, aws_subnet.private_2.id] }
output "alb_sg_id"          { value = aws_security_group.alb_sg.id }
output "ec2_sg_id"          { value = aws_security_group.ec2_sg.id }
