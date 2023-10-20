# SSH into this public IP address:
# ssh -i ~/.aws/aws/keypairs/devops.pem ec2-user@18.193.113.2
output "ec2_instance_ip" {
	value = module.ec2_instance.public_ip
}
