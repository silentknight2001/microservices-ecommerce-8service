# general variable ............. 
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "ecommerce-devopsify"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

# VPC variable ............. 

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-south-1", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR block for public subnet"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR block for private subnet"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

# EKS variable ........ 

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "ecommerce-eks"
}

variable "cluster_version" {
  description = "kubernetes version"
  type        = string
  default     = "1.29"
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_min_size" {
  description = "minimum number of worker node"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker node"
  type        = number
  default     = 3
}

variable "node_desired_size" {
  description = "Desired number of worker node"
  type        = number
  default     = 2
}
