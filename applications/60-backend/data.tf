data "aws_ssm_parameter" "backend_sg_id" {
    name ="/${var.project_name}/${var.environment}/backend_sg_id" # we will get this value from security group.
}
data "aws_ssm_parameter" "private_subnet_ids" {
    name ="/${var.project_name}/${var.environment}/private_subnet_ids" # We will get this value from VPC
}
data "aws_ssm_parameter" "vpc_id" {
    name ="/${var.project_name}/${var.environment}/vpc_id" # we will get this value from security group.
}
data "aws_ssm_parameter" "app_alb_listener_arn" {
    name ="/${var.project_name}/${var.environment}/app_alb_listener_arn" # we will get this value from security group.
}
data "aws_ami" "ami_info" {  # To get ami_id, we can use this data source.

    most_recent = true
    owners = ["973714476881"]

    filter {
        name = "name"
        values = ["RHEL-9-DevOps-Practice"]
        }

    filter {
         name ="root-device-type"
         values = ["ebs"]
        }

    filter {
         name ="virtualization-type"
         values = ["hvm"]
  }
}