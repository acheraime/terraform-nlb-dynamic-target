locals {
  engine  = "postgres"
  major_engine_version = "15"
  family = "${local.engine}${local.major_engine_version}"
  port = "5432"
  instance_class = "db.t3.micro"
  instance_name = "example-postgres"
  storage = 10
  max_storage = 20
}
