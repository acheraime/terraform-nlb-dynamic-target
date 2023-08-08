# Create a RDS instance

module "rds" {
    source = "terraform-aws-modules/rds/aws"
    version = "6.1.1"

    identifier = local.instance_name
    engine = local.engine
    major_engine_version = local.major_engine_version
    instance_class = local.instance_class
    allocated_storage = local.storage
    max_allocated_storage = local.max_storage
    family = local.family

    db_name = "postgres"
    username = "postgres"
    password = "notTooSafePassword"
    port = local.port

    create_db_subnet_group = false
    db_subnet_group_name = aws_db_subnet_group.example.name
    subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]

    depends_on = [aws_db_subnet_group.example]
}