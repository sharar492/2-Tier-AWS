module "network" {
  source = "../network"
}

# AWS Instances
resource "aws_instance" "web_server_1" {
  ami             = "ami-04e5276ebb8451442"
  instance_type   = "t2.micro"
  associate_public_ip_address = true
  subnet_id       = module.network.subnet_ids["public_1"]

  tags = {
    Name = "web-server-1"
  }

  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y 
sudo systemctl enable nginx
sudo systemctl start nginx
EOF
}

resource "aws_instance" "web_server_2" {
  ami             = "ami-04e5276ebb8451442"
  instance_type   = "t2.micro"
  associate_public_ip_address = true
  subnet_id       = module.network.subnet_ids["public_2"]

  tags = {
    Name = "web-server-2"
  }

  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y 
sudo systemctl enable nginx
sudo systemctl start nginx
EOF
}

# Load Balancer Creation
resource "aws_lb" "app_lb" {
  name               = "two-layer-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.network.web_security_group_id]
  subnets            = [
    module.network.subnet_ids["public_1"],  # Use public subnets
    module.network.subnet_ids["public_2"]
  ]

  tags = {
    environment = "two-tier-app"
  }
}

resource "aws_lb_target_group" "two-tier-lb-tg" {
  name     = "two-tier-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
}

# Create Load Balancer listener
resource "aws_lb_listener" "two-tier-lb-listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.two-tier-lb-tg.arn
  }
}

# Create Target group
resource "aws_lb_target_group_attachment" "two-tier-tg-attch-1" {
  target_group_arn = aws_lb_target_group.two-tier-lb-tg.arn
  target_id        = aws_instance.web_server_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "two-tier-tg-attch-2" {
  target_group_arn = aws_lb_target_group.two-tier-lb-tg.arn
  target_id        = aws_instance.web_server_2.id
  port             = 80
}
