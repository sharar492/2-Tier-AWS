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
    db_subnet_group_name = aws_db_subnet_group.two-tier-sub.name
}

resource "aws_db_subnet_group" "two-tier-sub" {
    name       = "two-tier-sub"
    subnet_ids = [
        module.network.subnet_ids["private_1"],
        module.network.subnet_ids["private_2"],
    ]
}


