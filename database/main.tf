# Configuring AWS Database / Hashicorp HCL RDS
module "network" {
  source = "../network"
}

resource "aws_db_instance" "db-1" {
    allocated_storage    = 20  
    engine               = "mysql"
    engine_version       = "8.0.35"  
    instance_class       = "db.m5d.large"  
    username             = "osharar"
    password             = "K3rching2020!"
    multi_az             = true
    skip_final_snapshot  = true

    # Define and associate the database subnet group
    db_subnet_group_name = aws_db_subnet_group.two-tier-sub.namemodule "network" {
  source = "../network"
}

resource "aws_db_instance" "db-1" {
    allocated_storage    = 20  
    engine               = "mysql"
    engine_version       = "8.0.35"  
    instance_class       = "db.m5d.large"  
    username             = "osharar"
    password             = "K3rching2020!"
    multi_az             = true
    skip_final_snapshot  = true
    db_subnet_group_name = aws_db_subnet_group.db_subnet.id
    vpc_security_group_ids = [module.network.web_security_group_id]
    parameter_group_name = "default.mysql8.0"
    tags = {
        Name = "Database Tier"
    }
}

# Database subnet group definition
resource "aws_db_subnet_group" "db_subnet" {
    name        = "db-subnet"
    description = "subnet for the database tier"
    subnet_ids  = [module.network.subnet_ids["private_1"], module.network.subnet_ids["private_2"]]
    tags = {
        Name = "Database Subnet"
    }
}

}

resource "aws_db_subnet_group" "two-tier-sub" {
    name       = "two-tier-sub"
    subnet_ids = [
        module.network.subnet_ids["private_1"],
        module.network.subnet_ids["private_2"],
    ]
}


