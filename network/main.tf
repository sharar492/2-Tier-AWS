# VPC Configuration
resource "aws_vpc" "VPC-Tier" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "VPC-Tier"
    }
}

# AWS Public Subnets
resource "aws_subnet" "subnet-public-1" {
    vpc_id     = aws_vpc.VPC-Tier.id
    cidr_block = var.subnet-public-1
}

resource "aws_subnet" "subnet-public-2" {
    vpc_id     = aws_vpc.VPC-Tier.id
    cidr_block = var.subnet-public-2
}

# AWS Private Subnets
resource "aws_subnet" "subnet-private-1" {
    vpc_id     = aws_vpc.VPC-Tier.id
    cidr_block = var.subnet-private-1
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet-private-2" {
    vpc_id     = aws_vpc.VPC-Tier.id
    cidr_block = var.subnet-private-2
    availability_zone = "us-east-1b"
}


# AWS Internet Gateway
resource "aws_internet_gateway" "IGW-2-Tier" {
    vpc_id = aws_vpc.VPC-Tier.id
    tags = {
        Name = "IGW-2-Tier"
    }
}

# Route Table Configuration
resource "aws_route_table" "two-tier-RT" {
    vpc_id = aws_vpc.VPC-Tier.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW-2-Tier.id
    }
}

# Route Table Association
resource "aws_route_table_association" "RT-Assoc" {
    subnet_id        = aws_subnet.subnet-public-1.id
    route_table_id   = aws_route_table.two-tier-RT.id
}

resource "aws_route_table_association" "RT-Assoc-2" {
    subnet_id        = aws_subnet.subnet-public-2.id
    route_table_id   = aws_route_table.two-tier-RT.id
}

# Security Group Configuration
resource "aws_security_group" "web-sg" {
    name        = "web-sg-two-tier-network-updated"  # Adjust the name to make it unique
    description = "security group for the web server (loadbalancer)"
    
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}



