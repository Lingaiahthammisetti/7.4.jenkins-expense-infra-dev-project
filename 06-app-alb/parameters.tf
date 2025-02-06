resource "aws_ssm_parameter" "app_alb_listener_arn" {
  name  = "/${var.project_name}/${var.environment}/app_alb_listener_arn" #This ARN will store its SG id in SSM Parameter store.
  type  = "String"
  value =  aws_lb_listener.http.arn
}
