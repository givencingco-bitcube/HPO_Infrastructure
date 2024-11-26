resource "aws_ecs_cluster" "api_app_cluster" {
  name = "hpo-staging-api-cluster"
}

resource "aws_ecs_task_definition" "api_app_task" {
  family                   = "hpo-api-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "hpo-api-task",
      "image": "${var.ecr_repo_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort":${var.container_port},
          "hostPort": ${var.container_port}
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "hpo-api-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment"  "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "demo_app_service" {
  name            = "hpo-api-service"
  cluster         = aws_ecs_cluster.api_app_cluster.id
  task_definition = aws_ecs_task_definition.api_app_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-target-group.arn
    container_name   = aws_ecs_task_definition.api_app_task.family
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = module.vpc.public_subnets
    assign_public_ip = true
    security_groups  = [module.ALB-security-group.security_group_id]
  }

   depends_on = [aws_lb_listener.alb-listerner]
}
