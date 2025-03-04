#
# RDBs
#

/*
resource "aws_db_instance" "my_database" {
  identifier              = "flashcard-db"
  engine                  = "mysql"        
  engine_version          = "8.0"         
  instance_class          = "db.t2.micro" 
  allocated_storage       = 20             
  storage_type            = "gp2"           
  db_name                 = "mydb"        
  username                = "admin"         
  password                = "password1234"  
  vpc_security_group_ids  = [aws_security_group.rds_sg.id] 
  publicly_accessible     = false           
  backup_retention_period = 7               
  multi_az                = true           

  # Attach DB subnet group for correct subnet selection
  db_subnet_group_name    = aws_subnet.private_rds_2a

  lifecycle {
    create_before_destroy = true  # Ensure a new DB instance is created before destroying the old one
  }

  tags = {
    Name = "MyBasicDatabase"
  }
}
*/


