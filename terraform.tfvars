aws_region   = "us-east-1"
environment  = "dev"
project_name = "terraform-demo"

vpc_cidr    = "10.0.0.0/16"
subnet_cidr = "10.0.1.0/24"

instance_type = "t3.micro" 

allowed_ssh_cidr = "0.0.0.0/0"
