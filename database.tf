#
# RDBs
#

resource "aws_db_instance" "my_database" {
  identifier              = "flashcard-db"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = "mydb"
  username                = var.db_username
  password                = var.db_password
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = false
  backup_retention_period = 7
  multi_az                = true
  db_subnet_group_name    = aws_db_subnet_group.main.name # Ensure your DB is in the right subnets

  lifecycle {
    create_before_destroy = true # Ensure a new DB instance is created before destroying the old one
  }

  tags = {
    Name = "MyBasicDatabase"
  }
}



