#  Terraform script pour créer une infrastructure AWS
# Utilise le fournisseur AWS pour provisionner les ressources

# Déclare une ressource pour créer une instance EC2
resource "aws_instance" "Ubuntu_web_server" {
  ami                         = var.ami # Utilisation de l'AMI spécifiée dans les variables
  instance_type               = var.instance_type # Type d'instance EC2 (par exemple, t2.micro)
  key_name                    = var.key_name # Nom de la paire de clés SSH pour accéder à l'instance
  subnet_id                   = aws_subnet.web_subnet.id # ID du sous-réseau dans lequel l'instance sera lancée
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id] # ID du groupe de sécurité associé à l'instance
  associate_public_ip_address = true # Associe une adresse IP publique à l'instance

  # Configuration de la connexion SSH
  connection {
    type        = "ssh" # Type de connexion (SSH)
    user        = var.ssh_user # Utilisateur SSH pour se connecter à l'instance
    private_key = file(var.private_key_path) # Chemin vers la clé privée pour l'accès SSH
    host        = self.public_ip # Utilise l'adresse IP publique de l'instance comme hôte
  }

  tags = {
    Name = "Ubuntu_Web_Server" # Nom de l'instance EC2 pour l'identification
  }
}

# Déclare une ressource pour créer une paire de clés SSH
resource "aws_key_pair" "web_server_key" {
  key_name   = var.key_name # Nom de la paire de clés
  public_key = file(var.public_key_path) # Chemin vers la clé publique pour l'accès SSH
}

# Déclare une ressource pour créer un groupe de sécurité
resource "aws_security_group" "web_server_sg" {
  vpc_id = aws_vpc.main_vpc.id # Associe le groupe de sécurité au VPC spécifié

  # Règle d'entrée pour autoriser les connexions SSH
  ingress {
    from_port   = 22 # Port source (SSH)
    to_port     = 22 # Port destination (SSH)
    protocol    = "tcp" # Protocole TCP
    cidr_blocks = ["0.0.0.0/0"] # Autorise les connexions depuis n'importe quelle adresse IP
  }

# Règle d'entrée pour autoriser les connexions HTTP
  ingress {
    from_port   = 80 # Port source (HTTP)
    to_port     = 80 # Port destination (HTTP)
    protocol    = "tcp" # Protocole TCP
    cidr_blocks = ["0.0.0.0/0"] # Autorise les connexions depuis n'importe quelle adresse IP
  }

  # Règle de sortie pour autoriser tout le trafic sortant
  egress {
    from_port   = 0 # Port source (tous les ports)
    to_port     = 0 # Port destination (tous les ports)
    protocol    = "-1" # Tous les protocoles
    cidr_blocks = ["0.0.0.0/0"] # Autorise les connexions vers n'importe quelle adresse IP
  }

  tags = {
    Name = "Web_Server_Security_Group" # Nom du groupe de sécurité
  }
}

# Déclare une ressource pour créer un VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16" # CIDR du VPC (plage d'adresses IP)
  tags = {
    Name = "Main_VPC" # Nom du VPC
  }
}

# Déclare une ressource pour créer un sous-réseau
resource "aws_subnet" "web_subnet" {
  vpc_id            = aws_vpc.main_vpc.id # Associe le sous-réseau au VPC spécifié
  cidr_block        = "10.0.1.0/24" # CIDR du sous-réseau (plage d'adresses IP)
  availability_zone = "eu-west-3a" # Zone de disponibilité (Paris)

  tags = {
    Name = "Web_Subnet" # Nom du sous-réseau
  }
}

# Déclare une ressource pour créer une passerelle Internet
resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id # Associe la passerelle Internet au VPC spécifié
}

# Déclare une ressource pour créer une table de routage
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id # Associe la table de routage au VPC spécifié

  # Ajoute une route pour permettre l'accès à Internet
  route {
    cidr_block = "0.0.0.0/0" # Route pour tout le trafic
    gateway_id = aws_internet_gateway.main_internet_gateway.id # Utilise la passerelle Internet comme cible
  }
}

# Associe la table de routage au sous-réseau
resource "aws_route_table_association" "web_subnet_route_association" {
  subnet_id      = aws_subnet.web_subnet.id # ID du sous-réseau
  route_table_id = aws_route_table.main_route_table.id # ID de la table de routage
}


