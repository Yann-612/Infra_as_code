variable "region" {
  description = "La region AWS dans laquelle déployer les ressources"
  # La région par défaut est Paris (eu-west-3)
  type        = string
  default     = "eu-west-3" # Paris
}

variable "instance_type" {
  description = "Le type d'instance EC2 à utiliser"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "L'ID de l'AMI à utiliser pour l'instance EC2"
  type        = string
}

variable "key_name" {
  description = "Le nom de la paire de clés SSH à utiliser pour accéder à l'instance EC2"
  # Le nom de la paire de clés SSH doit correspondre à celui créé dans AWS
  type        = string
}

variable "desired_capacity" {
  description = "La capacité désirée du groupe Auto Scaling"
  type        = number
  default     = 1
}

variable "access_key" {
  description = "la clée d'accès AWS pour l'authentification"
  type        = string
}

variable "secret_key" {
  description = "la clée secrète AWS pour l'authentification"
  type        = string
}

variable "private_key_path" {
  description = "Chemin vers le fichier de clé privée SSH"
  type        = string
}

variable "ssh_user" {
  description = "Utilisateur SSH par défaut pour se connecter à l'instance"
  type        = string
  default     = "ubuntu" # Utilisateur par défaut pour Ubuntu
}

variable "public_key_path" {
  description = "Chemin vers le fichier de clé publique SSH"
  type        = string
}
