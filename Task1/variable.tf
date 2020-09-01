variable "Project_Name" {
  default = "div_proj" #This will be default prefix of all the resources.
}
//variable "Public_Key" {} # default = file("c:/%username%/.ssh/id_rsa.pub")
variable "Region" {
  default = "ap-south-1"
}
variable "AMI" {
  default = "ami-0447a12f28fddb066"
}
variable "Instance_Type" {
  default = "t2.micro"
}
variable "VPC_ID" {
  default = "vpc-0f938e67" #Default Mumbai Region VPC for My AWS account.
}
variable "Bucket_Name" {
  default = "divbucket01"
}