aws_region = "us-east-1"

# AMI Amazon Linux 2 (mais estável pra EC2 + Docker)
ami = "ami-0c02fb55956c7d316"

instance_type = "t2.micro"

key_name = "my-key"

# ===== DATABASE =====
db_user     = "postgres"
db_password = "StrongPassword123!"
db_name     = "appdb"