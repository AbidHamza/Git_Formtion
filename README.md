# Atelier Git — Historique propre avant PR

Atelier pratique : créer un repo avec un historique volontairement « sale », puis le nettoyer avec `amend`, `rebase -i` et `reset`.

## Contenu

- **lab-pratique.md** — Énoncé du lab, étapes et commandes.
- **creer-depot-atelier.ps1** — Script Windows pour générer le repo avec l’historique sale.
- **creer-depot-atelier.sh** — Script Linux/macOS pour générer le repo avec l’historique sale.

## Démarrage

1. Clone ce repo ou télécharge les fichiers.
2. Soit tu suis **lab-pratique.md** dès l’étape 1 (créer le repo à la main).
3. Soit tu exécutes le script pour avoir directement un repo « sale », puis tu enchaînes à l’étape 3 du lab.
   - Windows : `.\creer-depot-atelier.ps1`
   - Linux/macOS : `chmod +x creer-depot-atelier.sh` puis `./creer-depot-atelier.sh`

Aucun conflit Git dans cet atelier. Repo local uniquement.
