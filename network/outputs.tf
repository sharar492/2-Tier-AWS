output "subnet_ids" {
  value = {
    public_1  = aws_subnet.subnet-public-1.id
    public_2  = aws_subnet.subnet-public-2.id
    private_1 = aws_subnet.subnet-private-1.id
    private_2 = aws_subnet.subnet-private-2.id
  }
}
output "web_security_group_id" {
  value = aws_security_group.web-sg.id
}
output "vpc_id" {
  value = aws_vpc.VPC-Tier.id
}
