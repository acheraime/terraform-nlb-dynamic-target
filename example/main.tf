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
    vpc_security_group_ids = [aws_security_group.example.id]

    depends_on = [aws_db_subnet_group.example]
}

# Loadbalancer and company
resource "aws_lb" "example" {
    name = "postgres-example"
    internal = true
    load_balancer_type = "network"
    subnets = [aws_subnet.a.id, aws_subnet.b.id]

    tags = {
        Name = "postgres-example"
    }
}

resource "aws_lb_listener" "example" {
    load_balancer_arn = aws_lb.example.arn
    port = local.port
    protocol = "TCP"
    default_action {
        target_group_arn = aws_lb_target_group.example.arn
        type = "forward"
    }
}

resource "aws_lb_target_group" "example" {
    name ="postgres-example"
    port = local.port
    protocol = "TCP"
    target_type = "ip"
    vpc_id = aws_vpc.example.id
}

resource "aws_lb_target_group_attachment" "example" {
    target_group_arn = aws_lb_target_group.example.arn
    availability_zone = module.rds.db_instance_availability_zone
    target_id = "192.168.1.67"
}