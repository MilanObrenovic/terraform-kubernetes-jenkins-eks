terraform {
  backend "s3" {
    # NOTE: a bucket with this exact name must be already created on AWS
    bucket = "terraform-kubernetes-jenkins-eks"
    key    = "eks/terraform.tfstate"
    region = "eu-central-1"
  }
}
