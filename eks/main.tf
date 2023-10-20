module "vpc" {
	# Use the AWS VPC module from the Terraform Registry
	source = "terraform-aws-modules/vpc/aws"

	# Set the name for the VPC
	name = "jenkins-vpc"
	# Define the VPC's CIDR block range
	cidr = var.vpc_cidr

	# Retrieve the availability zone names
	azs = data.aws_availability_zones.azs.names

	# Define the list of private and public subnets
	private_subnets = var.private_subnets
	public_subnets  = var.public_subnets

	# Enable DNS hostnames for resources in the VPC
	enable_dns_hostnames = true
	# Enable NAT gateway for allowing outbound internet access from private subnets
	enable_nat_gateway   = true
	# Enable a single NAT gateway to serve all private subnets in the VPC
	single_nat_gateway   = true

	# Tags for the VPC
	tags = {
		"kubernetes.io/cluster/my-eks-cluster" = "shared"
	}

	# Tags for public subnets
	public_subnet_tags = {
		"kubernetes.io/cluster/my-eks-cluster" = "shared"
		"kubernetes.io/role/elb"               = 1
	}

	# Tags for private subnets
	private_subnet_tags = {
		"kubernetes.io/cluster/my-eks-cluster" = "shared"
		"kubernetes.io/role/internal-elb"      = 1
	}
}

module "eks" {
	# Use the AWS EKS module from the Terraform Registry
	source = "terraform-aws-modules/eks/aws"

	# Specify the name for the EKS cluster
	cluster_name    = "my-eks-cluster"
	# Set the desired Kubernetes version for the EKS cluster
	cluster_version = "1.27"

	# Reference the VPC ID created by the `module.vpc`
	vpc_id     = module.vpc.vpc_id
	# Reference the private subnets from the `module.vpc` to launch EKS nodes in private subnets
	subnet_ids = module.vpc.private_subnets

	# Define the managed node group(s) configuration within the EKS cluster
	eks_managed_node_groups = {
		node = {
			# Set the minimum, maximum, and desired number of nodes in the node group
			min_size     = 1
			max_size     = 3
			desired_size = 2

			# Specify the instance type(s) for the nodes
			instance_type = ["t2.small"]
		}
	}

	# Add tags to resources created by this module, such as the EKS cluster
	tags = {
		Environment = "dev"
		Terraform   = "true"
	}
}
