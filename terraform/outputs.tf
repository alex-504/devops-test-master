output "ecr_repository_url" {
  description = "URL of the ECR repository for Docker images"
  value       = aws_ecr_repository.beer_app.repository_url
}

output "rds_endpoint" {
  description = "Endpoint of the RDS PostgreSQL database"
  value       = aws_db_instance.beer_database.endpoint
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app.name
} 