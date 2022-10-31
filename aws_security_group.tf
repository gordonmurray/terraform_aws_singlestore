resource "aws_security_group" "singlestore" {
  name        = "singlestore"
  description = "singlestore security group"
  vpc_id      = var.vpc_id
}