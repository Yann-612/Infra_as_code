variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-west-3" # Default region set to Paris
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-0160e8d70ebc43ee1" # Valeur par défaut (modifiable)
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default     = "id_ed2551"
}

variable "desired_capacity" {
  description = "The desired number of instances in the Auto Scaling group"
  type        = number
  default     = 1
}

variable "access_key" {
  description = "The AWS access key for authentication"
  type        = string
}

variable "secret_key" {
  description = "The AWS secret key for authentication"
  type        = string
}

variable "private_key_path" {
  description = "The path to the private key for SSH access"
  type        = string
}