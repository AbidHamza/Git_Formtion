#!/usr/bin/env sh
# Script pour créer le dépôt atelier Git (historique volontairement "sale")
# Usage : ./creer-depot-atelier.sh
# Exécuter depuis le dossier où tu veux créer le repo (ex. Bureau, ~/formations).

set -e
DIRNAME="git-lab-clean-history"

if [ -d "$DIRNAME" ]; then
  echo "Le dossier $DIRNAME existe déjà. Supprime-le ou choisis un autre emplacement."
  exit 1
fi

mkdir "$DIRNAME"
cd "$DIRNAME"

git init

# Commit 1 : init
echo "# Mon projet" > README.md
git add README.md
git commit -m "init"

# Commit 2 : add file
echo "def hello(): pass" > main.py
git add main.py
git commit -m "add file"

# Commit 3 : wip
echo "def hello(): return 'hi'" >> main.py
git add main.py
git commit -m "wip"

# Commit 4 : fix
echo "# TODO" >> main.py
git add main.py
git commit -m "fix"

# Commit 5 : fix typo
echo "def bye(): pass" >> main.py
git add main.py
git commit -m "fix typo"

# Commit 6 : oups
echo "" >> main.py
git add main.py
git commit -m "oups"

echo ""
echo "Dépôt créé dans $(pwd)"
echo "Historique actuel (sale) :"
git log --oneline -6
echo ""
echo "Tu peux enchaîner sur l'atelier : amend, rebase -i, reset. Voir les slides ou lab-pratique.md."
