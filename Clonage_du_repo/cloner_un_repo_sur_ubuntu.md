#####   Cloner un repo #privé# Git-Hub sur une Vm Ubuntu Serveur  ######

git clone [ le nom de votre repo ] ###  git clone https://github.com/Yann-612/Infra_as_code.git

## renseigner l'identiiant Git-Hub 

## le mot de passe à etre generer sur Git-Hub

## Aller dans: Profile >> Settings >> Develper settings >> Personal access tokens >> Tokens (Classic) >> Generate new token >> Selction des droits d'acces >> ensuite generer le token.

## entrez la clé dasn la case mdp

## Le probleme c'est qu'a chaque synchro du repo il va vous redemander les identifiants et mdp

## la  solution reste temporaire à moins de l'inscrire de facon permanente.

## Se mettre sur l'arboresence du repo et generer une nouvelle paire de clé "privée/public" en tapant la commande ci-dessous

ssh-keygen -t ed25519 -C "[email-utilisé-pour-Github]"  ##### example : ssh-keygen -t ed25519 -C "yannick.ahyoune@gmail.com"


## Une fois la paire de clé généré taper la commande suivante pour utiliser la clé privée: 

## toujours sur le dossier du repo

eval $(ssh-agent -s)

ssh-add ~/.ssh/clé_privée  ## penser à se mettre dans l'arborescence ou a été generé la clé

## Ensuite copier le contenu de la clé public pour le coller sur GitHub dans: Profile >> Settings >> SSH and GPG keys > New SSH key

## Une fois la clé pubilc ajoutée, pour tester tapez la commande suivante :

ssh -T git@github.com  #### et suivre les instructions


## Derniere commande à taper: en se mettant sur dossier repo

git remote set-url origin git@github.com:Yann-612/Infra_as_code.git


git pull origin main ## normalement il est pas censé de vous redemander des id et mdp



##  A chaque modification du fichier sur le repo cloné:

git add --all 

git commit -m "new changes"

git push

## fin

## ps: a renseigner éventuellement lors des commits
git config --global user.name "Yannick"
git config --global user.email "yannick.ahyoune@gmail.com"

