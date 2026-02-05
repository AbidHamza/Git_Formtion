# Règles Tech Lead — Git (historique propre)

10 à 12 règles applicables en équipe, orientées sécurité, lisibilité et collaboration. Utilisables comme base de standards internes.

---

1. **Nettoyer l’historique en local avant le premier push.**  
   Amend, rebase -i et reset sont sans impact pour les autres tant que la branche n’a pas été poussée. Après push, toute réécriture se coordonne.

2. **Un commit = une intention.**  
   Un commit regroupe les changements qui forment une seule modification logique (feature, fix, refactor). Pas un commit par fichier par défaut.

3. **Messages de commit explicites.**  
   Le message décrit le « quoi » et si besoin le « pourquoi », pas le « comment » (le diff le montre). Adopter une convention (ex. type: description) et l’appliquer en review.

4. **Pas de force-push sur les branches partagées sans accord.**  
   main (ou équivalent) est protégée. Sur les branches de feature, force-push après rebase/amend uniquement si personne n’a tiré la branche, ou après coordination.

5. **Rebase uniquement sur sa branche de feature et avant partage.**  
   Rebase -i pour nettoyer ses commits avant d’ouvrir la PR. Une fois la branche poussée et utilisée par d’autres, ne pas rebaser sans prévenir.

6. **Vérifier l’historique avant d’ouvrir une PR.**  
   `git log --oneline -n 10` avant push. Corriger les "wip", "fix", typos et commits redondants avec amend ou rebase -i.

7. **Reflog comme filet de sécurité.**  
   Avant une opération destructive (reset --hard, rebase), savoir que `git reflog` permet de retrouver l’état précédent. En cas de doute, vérifier reflog après l’opération.

8. **Décider en équipe : squash ou merge commit en PR.**  
   Choisir une règle (squash and merge vs merge commit) et l’appliquer de façon cohérente. Documenter le choix dans le CONTRIBUTING ou le README.

9. **En review, exiger un historique lisible.**  
   La revue de code inclut la lecture de l’historique de la PR. Historique sale = demande de nettoyage (rebase/squash) avant merge.

10. **Standardiser par une page de règles et la review.**  
    Une courte page « Git » (messages, pas de push direct sur main, nettoyage avant PR) + application en review suffit. Les outils (hooks, CI) viennent en renfort, pas en remplacement.

11. **Réserver reset --hard aux cas maîtrisés.**  
    Utiliser --soft ou --mixed quand on veut déplacer la branche sans perdre le travail. --hard uniquement quand on sait ce qu’on fait et qu’on a reflog en tête.

12. **Coordonner après une réécriture partagée.**  
    Si tu as rebasé ou amendé une branche déjà pullée par d’autres : les prévenir et indiquer la procédure (reset --hard origin/branche ou rebase de leur travail sur la nouvelle tête).

---

Ces règles peuvent être copiées dans un wiki, un CONTRIBUTING.md ou un document « Standards Git » interne.
