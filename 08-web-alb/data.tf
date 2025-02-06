data "aws_ssm_parameter" "web_alb_sg_id" {
    name ="/${var.project_name}/${var.environment}/web_alb_sg_id" # we will get this value from security group.
}
data "aws_ssm_parameter" "public_subnet_ids" {
    name ="/${var.project_name}/${var.environment}/public_subnet_ids" # We will get this value from VPC
}
data "aws_ssm_parameter" "acm_certificate_arn" {
    name ="/${var.project_name}/${var.environment}/acm_certificate_arn" # We will get this value from VPC
}

