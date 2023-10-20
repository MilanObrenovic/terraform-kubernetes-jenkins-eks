# Terraform + Kubernetes + Jenkins + AWS EKS

This repository focuses on a minimal DevOps setup to deploy any application via Jenkins, on Amazon Elastic Kubernetes
Service (EKS) Cluster, through Terraform.

# 1. Kubernetes (K8S)

- EKS is a managed service that is provided by AWS.
- Kubernetes has multiple components, but the main ones are **Control Plane** and **Worker Nodes**.

## 1.1. Control Plane

- Control Plane (also known as Master Node) is a service that manages control over the overall cluster.
- It will be managed by AWS EKS Cluster, so as DevOps engineers, we can focus only on Worker Nodes.
- You don't have to create the control plane from scratch because that is already done by EKS.

## 1.2. Worker Nodes

- Worker Nodes are services on which the applications will be running.
- There can be multiple worker nodes.
- As a DevOps engineer (or customer of AWS), we are going to create and manage worker nodes.

## 1.3. Kubernetes on Different Cloud Providers

- **EKS (Elastic Kubernetes Service)** – Amazon.
- **AKS (Azure Kubernetes Service)** – Microsoft.
- **GKE (Google Kubernetes Engine)** – Google.
- **OKE (Oracle Kubernetes Engine)** – Oracle.

# 2. Terraform

- Terraform is an Infrastructure as Code (IaC) tool that can create any component from any of the previously mentioned
	Cloud Providers with the help of declarative code.

# 3. Jenkins

- Jenkins is nothing but a CI/CD management tool.

## 3.1. CI/CD

- In software development, general workflow goes like this:

1. Code
2. Build
3. Test
4. Deploy (automated)

- All of these processes can be automated with Jenkins.

# 4. Terraform CI/CD Pipeline

- The pipeline workflow will go like this:

1. Software developed and Terraform DevOps code written.
2. Pushed to GitHub repository which triggers the Jenkins pipeline.
3. Jenkins CI/CD pipeline deploys changes to EKS Cluster.

# 5. Process

1. Create EC2 instance through Terraform and then deploy Jenkins on it.
2. Write Terraform code for EKS Cluster.
3. Push the code on GitHub.
4. Create a Jenkins pipeline which is going to deploy the code on EKS Cluster.
5. Deploy the changes to AWS.
6. Implement a deployment file with the help of `kubectl` which will deploy an NGINX application on our EKS cluster, and
	 then we'll be accessing that particular application with the help of Load Balancer.

# 6. Networking

- In [terraform.tfvars](jenkins-server/terraform.tfvars) of the Jenkins server, for example, a VPC and CIDR has been
	defined:

```hcl
vpc_cidr       = "192.168.0.0/16"
public_subnets = ["192.168.1.0/24"]
```

- As a refresher, this is how it works:

## 6.1. `vpc_cidr`

- `vpc_cidr = "192.168.0.0/16`:
	- `vpc_cidr` defines the IP address range for the VPC, and it's specified using CIDR notation.
	- In this case, it's set to `192.168.0.0/16`.
	- The `/16` in the CIDR notation means that this VPC has a total of 65,536 IPv4 addresses (2^16).
	- The VPC range is from `192.168.0.0` to `192.168.255.255`, which provides a large address space for the VPC
		resources.
	- Example IP addresses within this VPC could be:
		- `192.168.1.10`
		- `192.168.2.20`
		- ...

## 6.2. `public_subnets`

- `public_subnets = ["192.168.1.0/24"]`:
	- `public_subnets` defines the IP address ranges for the public subnets within the VPC.
	- In this case, it specifies a list with one public subnet, `192.168.1.0/24`.
	- The `/24` in the CIDR notation means that this subnet has 256 IPv4 addresses (2^8).
	- The public subnets IP range is from `192.168.1.0` to `192.168.1.255`.
	- Example IP addresses within this public subnet could be:
		- `192.168.1.10`
		- `192.168.1.20`
		- ...

## 6.3. How is IP Address Size Calculated?

- `/16`:
	- In a CIDR notation like `/16`, the number after the slash (`/`), represents the number of bits that are fixed for
		the network portion of the IP address.
	- IPv4 addresses are **32 bits in total**.
	- In a `/16` notation, the leftmost 16 bits are fixed for the network, leaving 16 bits for host addresses (32-16=16).
	- With 16 bits for hosts, you have 2^16 (or 65,536) possible host addresses within that network.
- `/24`:
	- In a CIDR notation like `/24`, 24 bits are fixed for the network portion of the IP address.
  - This leaves 8 bits for host addresses (32-24=8).
  - With 8 bits for hosts, you have 2^8 (or 256) possible host addresses within that network.
