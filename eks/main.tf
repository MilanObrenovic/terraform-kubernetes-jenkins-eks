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
