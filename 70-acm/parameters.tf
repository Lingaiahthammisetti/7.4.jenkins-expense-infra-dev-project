resource "aws_ssm_parameter" "acm_certificate_arn" {
  name  = "/${var.project_name}/${var.environment}/acm_certificate_arn" #This ARN will store its SG id in SSM Parameter store.
  type  = "String"
  value =  aws_acm_certificate.expense.arn
}


