#
# DB Subnet Group
#

resource "aws_db_subnet_group" "flashcard_db_subnet_group" {
  name       = "flashcard-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = {
    Name = "flashcard-db-subnet-group"
  }
}

resource "aws_security_group" "flashcard_rds_sg" {
  name        = "flashcard-rds-sg"
  description = "Allow database access from the application layer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306  # MySQL (use 5432 for PostgreSQL)
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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