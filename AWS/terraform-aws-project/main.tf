# Déclare une source de données pour rechercher une AMI Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true                     # Récupère l'AMI la plus récente correspondant aux filtres
  owners      = ["amazon"]               # Limite la recherche aux AMIs appartenant à Amazon

  filter {                               # Applique un filtre pour affiner la recherche
    name   = "name"                      # Filtre basé sur le nom de l'AMI
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Recherche les AMIs Amazon Linux 2 (HVM, 64 bits, stockage GP2)
  }
}

# Déclare une ressource pour créer une instance EC2
resource "aws_instance" "Ubuntu_web_server" {
  ami           = data.aws_ami.amazon_linux.id # Utilise l'AMI Amazon Linux 2 trouvée précédemment
  instance_type = var.instance_type          # Utilise la variable pour le type d'instance
  key_name      = var.key_name               # Nom de la paire de clés SSH pour accéder à l'instance
  subnet_id     = aws_subnet.example.id      # ID du sous-réseau dans lequel l'instance sera lancée
  vpc_security_group_ids = [aws_security_group.example.id] # ID du groupe de sécurité à associer à l'instance
  associate_public_ip_address = true        # Associe une adresse IP publique à l'instance

  tags = {
    Name = "Ubuntu_web_server"            # Nom de l'instance EC2
  }
}

# Déclare une ressource pour créer un groupe de sécurité
resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id # Associe le groupe de sécurité au même VPC que le sous-réseau

  ingress {                                   # Règle d'entrée pour autoriser les connexions SSH
    from_port   = 22                          # Port source (SSH)
    to_port     = 22                          # Port destination (SSH)
    protocol    = "tcp"                       # Protocole TCP
    cidr_blocks = ["0.0.0.0/0"]               # Autorise les connexions depuis n'importe quelle adresse IP
  }

  egress {                                    # Règle de sortie pour autoriser tout le trafic sortant
    from_port   = 0                           # Port source (tous les ports)
    to_port     = 0                           # Port destination (tous les ports)
    protocol    = "-1"                        # Tous les protocoles
    cidr_blocks = ["0.0.0.0/0"]               # Autorise les connexions vers n'importe quelle adresse IP
  }

  tags = {
    Name = "example-security-group"           # Nom du groupe de sécurité
  }
}

# Déclare une ressource pour créer un VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"                  # CIDR du VPC
  tags = {
    Name = "example-vpc"                      # Nom du VPC
  }
}

# Déclare une ressource pour créer un sous-réseau
resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id      # Associe le sous-réseau au même VPC
  cidr_block        = "10.0.1.0/24"           # CIDR du sous-réseau
  availability_zone = "eu-west-3a"            # Zone de disponibilité (Paris)

  tags = {
    Name = "example-subnet"                   # Nom du sous-réseau
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}

