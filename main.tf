# VPC
# Create a VPC for a Jenkins server with public subnets and DNS hostnames enabled
module "vpc" {
	# Use the AWS VPC module from the Terraform Registry
	source = "terraform-aws-modules/vpc/aws"

	# Set the name for the VPC
	name = "jenkins-vpc"
	# Define the VPC's CIDR block range
	cidr = var.vpc_cidr

	# Retrieve the availability zone names
	azs            = data.aws_availability_zones.azs.names
	# Define the list of public subnets
	public_subnets = var.public_subnets

	# Automatically assign public IP addresses to instances in the public subnets
	map_public_ip_on_launch = true
	# Enable DNS hostnames for resources in the VPC
	enable_dns_hostnames    = true

	# Set tags for the VPC
	tags = {
		Name        = "jenkins-vpc"
		Terraform   = "true"
		Environment = "dev"
	}

	# Set tags for the public subnets
	public_subnet_tags = {
		Name = "jenkins-subnet"
	}
}

# SG
# Create a security group for Jenkins server with specific ingress and egress rules
module "sg" {
	#  Use the AWS security group module
	source = "terraform-aws-modules/security-group/aws"

	# Set the name for the security group
	name        = "jenkins-sg"
	# Provide a description for the security group
	description = "Security Group for Jenkins Server."
	# Associate the security group with the VPC created earlier
	vpc_id      = module.vpc.vpc_id

	# Define inbound rules for the security group
	ingress_with_cidr_blocks = [
		{
			# Allow incoming HTTP traffic so that we can access Jenkins server on port 8080
			from_port   = 8080
			to_port     = 8080
			protocol    = "tcp"
			description = "HTTP"
			cidr_blocks = "0.0.0.0/0"
		},
		{
			# Allow incoming SSH traffic so that we can access via SSH
			from_port   = 22
			to_port     = 22
			protocol    = "tcp"
			description = "SSH"
			cidr_blocks = "0.0.0.0/0"
		}
	]

	# Define outbound rules for the security group
	egress_with_cidr_blocks = [
		{
			# Allow all outbound traffic from the Jenkins server
			from_port   = 0
			to_port     = 0
			protocol    = "-1"
			cidr_blocks = "0.0.0.0/0"
		}
	]

	# Set tags for the security group
	tags = {
		Name = "jenkins-sg"
	}
}

# EC2
module "ec2_instance" {
	# Use the AWS EC2 instance module from the Terraform Registry
	source = "terraform-aws-modules/ec2-instance/aws"

	# Set a name for the EC2 instance
	name = "Jenkins-Server"

	# Specify the EC2 instance type from a variable
	instance_type               = var.instance_type
	# Define the SSH key pair name to be used for instance access
	key_name                    = "devops"
	# Enable detailed monitoring for the EC2 instance
	monitoring                  = true
	# Associate the EC2 instance with a security group defined in a separate module
	vpc_security_group_ids      = [module.sg.security_group_id]
	# Specify the subnet for the EC2 instance. Use the first public subnet created in the VPC
	subnet_id                   = module.vpc.public_subnets[0]
	# Assign a public IP address to the EC2 instance so we can access the Jenkins server through it
	associate_public_ip_address = true
	# Provide user data script for EC2 instance configuration
	user_data                   = file("jenkins-install.sh")
	# Set the availability zone for the EC2 instance
	availability_zone           = data.aws_availability_zones.azs.names[0]

	# Set tags for the EC2 instance
	tags = {
		Name        = "Jenkins-Server"
		Terraform   = "true"
		Environment = "dev"
	}
}
