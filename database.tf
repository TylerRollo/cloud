#
# DB Subnet Group
#




#
# RDBs
#

/* 

resource "aws_db_instance" "flashcard_rds" {
  identifier             = "flashcard-db"
  engine                = "mysql"  # Use "postgres" for PostgreSQL
  instance_class        = "db.t2.micro"  # Free-tier eligible
  allocated_storage     = 20
  storage_type          = "gp3"
  username             = "admin"
  password             = ""
  db_subnet_group_name  = aws_db_subnet_group.flashcard_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.flashcard_rds_sg.id]
  multi_az             = false
  publicly_accessible  = false  # Ensure it's private
  skip_final_snapshot  = true  # Set to false in production

  tags = {
    Name = "flashcard-db"
  }
}

*/