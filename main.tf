module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"

  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = var.key_name
  vpc_id        = module.vpc.vpc_id

  db_host = split(":", module.rds.endpoint)[0]
  db_user     = var.db_user
  db_password = var.db_password
  db_name     = var.db_name
}

module "rds" {
  source = "./modules/rds"

  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id
  ec2_sg_id  = module.ec2.sg_id
}

# 🔥 OUTPUT ADICIONADO
output "rds_endpoint" {
  value = module.rds.endpoint
}