variable "project_name" {
    description = "Project name"
    type = string
}

variable "environment" {
    description = "environment name"
    type = string
}

variable "cluster_name" {
    description = "Eks Cluster name"
    type = string
}

variable "cluster_version" {
    description = "Kubernetes version"
    type = string  
}

variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "private_subnet_ids" {
    description = "Private subnet ids for worker node"
    type = list(string)
  
}

variable "public_subnet_ids" {
    description = "Public subnet ids for loadbalancer"
    type = list(string)
  
}
variable "eks_cluster_role_arn" {
    description = "IAM role aen for EKS cluster"
    type = string 

  
}
 variable "eks_node_group_role_arn" {
    description = "IAM role arn for eks cluster"
    type = string
   
 }

 variable "eks_cluster_sg_id" {
    description = "Security group ID for EKS cluster"
    type = string
   
 }

variable "eks_nodes_sg_id" {
    description = "Security id for eks node"
    type = string
  
}
variable "node_instance_type" {
    description = "Ec2 instance type for worker nodes"
    type = string
}
 variable "node_min_size" {
    description = "Minimum number of worker node"
    type = number
 }

 variable "node_max_size" {
    description = "Maximum number of woker node"
    type = string
 }
variable "node_desired_size" {
    description = "Desizer number of worker node"
    type = number
}
