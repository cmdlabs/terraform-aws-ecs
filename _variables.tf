# == REQUIRED VARS

variable "name" {
  description = "Name of your ECS cluster"
}

variable "instance_type" {
  description = "Instance type for ECS workers"
}

variable "vpc_id" {
  description = "VPC id to deploy ECS"
}

variable "private_subnet_ids" {
  type        = "list"
  description = "private subnet id list for ECS instances"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "public subnet id list for ECS ALB"
}

variable "secure_subnet_ids" {
  type        = "list"
  description = "secure subnet id list for EFS"
}

variable "certificate_arn" {}

# == OPTIONAL VARS

variable "alb" {
  default     = false
  description = "Whether to deploy an ALB or not with the cluster"
}

variable "asg_min" {
  default = 1
}

variable "asg_max" {
  default = 4
}
