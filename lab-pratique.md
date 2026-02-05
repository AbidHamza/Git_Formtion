# Lab pratique — Historique propre avant PR

Repo local uniquement. Aucun conflit Git. Fichiers simples. Reproductible par tous les participants.

---

## Objectif

Créer un dépôt local, générer volontairement un historique « sale », puis le nettoyer avec amend, rebase -i et reset. À la fin, tu dois avoir un historique lisible et cohérent.

---

## Étape 0 : Préparation

Ouvre un terminal. Choisis un répertoire de travail (ex. Bureau ou ~/formations). Toutes les commandes sont à exécuter dans l’ordre.

**Option :** exécuter le script pour obtenir directement un repo avec l’historique sale, puis enchaîner à l’étape 3.
- Windows (PowerShell) : `.\creer-depot-atelier.ps1` (depuis le dossier où se trouve le script, ou copie le script dans ton dossier de travail).
- Linux / macOS : `chmod +x creer-depot-atelier.sh` puis `./creer-depot-atelier.sh`.
Le script crée le dossier `git-lab-clean-history` avec l’historique déjà « sale ». Tu peux alors entrer dans ce dossier et faire les étapes 3 à 6.

---

## Étape 1 : Créer le repo et un premier commit

```bash
mkdir git-lab-clean-history
cd git-lab-clean-history
git init
```

Crée un fichier et commit :

```bash
echo "# Mon projet" > README.md
git add README.md
git commit -m "init"
```

Vérification : `git log --oneline` doit afficher un seul commit (init).

---

## Étape 2 : Générer un historique volontairement sale

Exécute les commandes suivantes une par une. L’objectif est d’obtenir plusieurs commits avec des messages peu clairs ou redondants.

```bash
echo "def hello(): pass" > main.py
git add main.py
git commit -m "add file"
```

```bash
echo "def hello(): return 'hi'" >> main.py
git add main.py
git commit -m "wip"
```

```bash
echo "# TODO" >> main.py
git add main.py
git commit -m "fix"
```

```bash
echo "def bye(): pass" >> main.py
git add main.py
git commit -m "fix typo"
```

```bash
echo "" >> main.py
git add main.py
git commit -m "oups"
```

Vérification : `git log --oneline -6`. Tu dois voir quelque chose comme : oups, fix typo, fix, wip, add file, init. Historique « sale » volontaire.

---

## Étape 3 : Nettoyer le dernier commit avec amend

Supposons que « oups » ne doit pas exister : on fusionne ce petit changement dans le commit précédent.

```bash
git reset --soft HEAD~1
git status
```

Tu dois voir le dernier changement (modification de main.py) en staging. Recommit en le fusionnant avec le commit précédent :

```bash
git commit --amend --no-edit
```

Vérification : `git log --oneline -5`. Le commit « oups » a disparu ; ses changements sont dans « fix typo ».

---

## Étape 4 : Renommer et fusionner des commits avec rebase -i

On va fusionner « add file », « wip », « fix » en un seul commit logique (ex. « add main module with hello and TODO ») et garder « fix typo » (qu’on peut renommer en « add bye and formatting »).

Lance :

```bash
git rebase -i HEAD~4
```

Un éditeur s’ouvre avec une liste du type :

```
pick abc1234 add file
pick def5678 wip
pick ghi9012 fix
pick jkl3456 fix typo
```

Modifie pour :

- Garder le premier en `pick`.
- Mettre le 2e et le 3e en `squash` (ou `s`).
- Garder le 4e en `pick` ; tu peux le passer en `reword` (ou `r`) si tu veux changer son message.

Exemple :

```
pick abc1234 add file
squash def5678 wip
squash ghi9012 fix
reword jkl3456 fix typo
```

Sauvegarde et quitte l’éditeur (sous vim : `Esc` puis `:wq` ; sous VS Code : sauvegarder et fermer l’onglet).

Si tu as mis `reword` sur le dernier, un second écran s’ouvre pour éditer le message (ex. « add bye() and minor formatting »). Sauvegarde et quitte.

Si tu as squasher les 2e et 3e commits, un écran te demande le message du commit fusionné. Remplace par un seul message clair, ex. « add main module with hello and TODO ». Sauvegarde et quitte.

Vérification : `git log --oneline -4`. Tu dois avoir moins de commits et des messages plus clairs.

---

## Étape 5 : (Optionnel) Tout remettre en un seul commit avec reset --soft

Si tu veux tout avoir dans un seul commit (sauf init) :

```bash
git log --oneline
```

Repère le hash du commit « init » (ou le premier commit après init). Puis :

```bash
git reset --soft <hash_du_commit_init>
git status
```

Tous les changements des commits suivants sont maintenant en staging. Un seul nouveau commit :

```bash
git commit -m "add main module: hello, bye, TODO and formatting"
```

Vérification : `git log --oneline`. Tu dois avoir deux commits : init et le nouveau.

---

## Étape 6 : Vérifier le reflog

Pour voir que Git a gardé une trace des anciennes positions de HEAD :

```bash
git reflog
```

Tu devrais voir des entrées correspondant à tes reset et rebase. En cas d’erreur, tu pourrais utiliser un de ces hash pour revenir en arrière (ex. `git reset --hard <hash>`).

---

## Récap des commandes utilisées

- `git init`, `git add`, `git commit`
- `git log --oneline`
- `git reset --soft HEAD~1`, `git commit --amend --no-edit`
- `git rebase -i HEAD~n` (pick, squash, reword)
- `git reset --soft <commit>` pour tout remettre en staging
- `git reflog`

---

## En cas de blocage

- **L’éditeur de rebase -i** : sauvegarder et quitter (vim : `:wq` ; VS Code : sauvegarder et fermer).
- **Tu veux annuler le rebase** : `git rebase --abort`.
- **Tu as fait une erreur** : `git reflog`, repérer le hash d’avant l’erreur, puis `git reset --hard <hash>`.

Aucun conflit n’est prévu dans ce lab ; si un conflit apparaît (par exemple après une modification manuelle), tu peux résoudre ou annuler avec `git rebase --abort` et recommencer l’étape.
