resource "aws_db_instance" "db_instance" {
  allocated_storage = 20
  storage_type      = "standard"
  engine            = "postgres"
  engine_version    = "12"
  instance_class    = "db.t2.micro"
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
}
