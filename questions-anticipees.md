# Questions anticipées — Tech Lead (Git historique propre)

Réponses courtes (30 s) et longues (si on insiste), avec phrase de clôture. Classées par thème.

---

## Concepts Git

**Q1 : C’est quoi exactement le staging ?**  
Réponse courte : C’est l’index Git : une zone intermédiaire entre ton répertoire de travail et l’historique. Ce que tu mets avec `git add` est « stagé » ; le prochain `git commit` enregistre uniquement ce qui est dans l’index.  
Réponse longue : L’index est un fichier binaire (souvent `.git/index`) qui décrit l’arbre des fichiers au prochain commit. `git status` compare working tree, index et HEAD pour afficher les différences.  
Clôture : « Le staging, c’est ton zone de préparation du prochain commit. »

**Q2 : HEAD, c’est quoi ?**  
Réponse courte : HEAD est la référence qui indique « le commit sur lequel tu es ». En général elle pointe vers une branche (ex. main), qui elle-même pointe vers un commit.  
Réponse longue : HEAD peut être « détachée » si tu fais `git checkout <hash>` : tu n’es plus sur une branche nommée. Reflog enregistre les déplacements de HEAD.  
Clôture : « HEAD, c’est "où je suis" dans l’historique. »

**Q3 : Pourquoi "history" est immutable alors qu’on fait amend et rebase ?**  
Réponse courte : Les objets commit en eux-mêmes ne sont jamais modifiés. Amend et rebase créent de nouveaux commits ; la branche pointe ailleurs. Les anciens commits restent dans le repo (reflog) jusqu’à ce qu’ils soient purgés.  
Réponse longue : Git est un graphe d’objets (blobs, trees, commits). Changer l’historique = créer de nouveaux commits et déplacer la référence de branche. Aucun objet existant n’est écrasé.  
Clôture : « L’immutabilité, c’est au niveau des objets. La branche, elle, bouge. »

---

## commit --amend

**Q4 : Est-ce que amend change le hash ?**  
Réponse courte : Oui. Un commit est identifié par son hash (SHA-1). Amend crée un nouveau commit avec un nouveau hash ; l’ancien n’est plus référencé par la branche.  
Réponse longue : Le hash dépend du contenu (arbre, parent(s), message, auteur, date). Dès que tu changes quoi que ce soit, le hash change.  
Clôture : « Amend = nouveau commit = nouveau hash. Toujours. »

**Q5 : Peut-on amend un commit qui n’est pas le dernier ?**  
Réponse courte : Pas avec `commit --amend`. Pour un commit plus ancien, tu utilises `rebase -i` avec l’action `reword` ou en insérant un `edit` pour modifier le contenu.  
Réponse longue : `rebase -i HEAD~n`, puis pour le commit visé : `edit`. Git s’arrête dessus ; tu fais tes modifs, `git add`, `git commit --amend`, puis `git rebase --continue`.  
Clôture : « Pour autre que le dernier, c’est rebase -i. »

**Q6 : Amend après un push, c’est grave ?**  
Réponse courte : Si personne n’a tiré la branche, un `git push --force-with-lease` réécrit l’historique distant. Si d’autres ont déjà pull, ils auront des conflits de référence ; il faut une procédure d’équipe (ex. prévenir, tout le monde reset sur la nouvelle tête).  
Réponse longue : Le push --force remplace la branche distante. Les collègues qui ont cette branche en local voient leur historique diverger. Ils doivent soit reset --hard sur origin/branche, soit rebase leur travail sur la nouvelle tête.  
Clôture : « Amend après push, c’est gérable si tout le monde est aligné ; sinon, on évite. »

---

## rebase interactif

**Q7 : Pourquoi ne pas toujours faire rebase ?**  
Réponse courte : Rebase réécrit l’historique. Dès que la branche est partagée (push), réécrire crée des doublons côté autres devs et peut casser leur historique. En local avant push : pas de souci.  
Réponse longue : Rebase = réécrire une suite de commits. Si quelqu’un a déjà basé son travail sur les anciens commits, ses références parent deviennent invalides. La règle courante : rebase sur des branches personnelles / feature non partagées ; sur main ou branche partagée, on évite sans accord.  
Clôture : « Rebase, oui en local ; une fois partagé, seulement si l’équipe est d’accord. »

**Q8 : Rebase -i et conflits : on fait quoi ?**  
Réponse courte : Git s’arrête au commit en conflit. Tu résous les conflits dans les fichiers, `git add`, puis `git rebase --continue`. Si tu veux annuler tout le rebase : `git rebase --abort`.  
Réponse longue : Pendant un rebase, Git rejoue les commits un par un. À chaque application (patch), un conflit peut survenir. Tu résous comme un merge classique, tu add et continue. Reflog garde l’état avant rebase au cas où.  
Clôture : « Conflit pendant rebase : résolution classique, puis --continue ou --abort. »

**Q9 : Squash vs merge commit en PR ?**  
Réponse courte : Squash : tous les commits de la branche fusionnés en un seul sur la cible (historique linéaire, une entrée par PR). Merge commit : on garde tous les commits et on ajoute un commit de merge (historique complet, plus de nœuds). Choix d’équipe : lisibilité vs traçabilité fine.  
Réponse longue : Squash simplifie l’historique de main et évite le bruit des "fix typo". Merge commit garde chaque commit de la feature, utile pour bisect ou blame plus fin. Certaines équipes imposent "squash and merge" dans la PR.  
Clôture : « C’est une convention d’équipe : squash pour un main propre, merge commit pour garder le détail. »

**Q10 : Peut-on faire un rebase -i sur main ?**  
Réponse courte : Techniquement oui. En pratique, si main est partagée et déjà poussée, c’est très risqué : tout le monde devrait resynchroniser. On réserve le rebase aux branches de feature avant merge.  
Réponse longue : Rebaser main revient à réécrire l’historique principal. Toutes les branches qui en partent deviennent incohérentes. En entreprise, main est souvent protégée contre force-push.  
Clôture : « Sur main partagée, on ne rebase pas sans processus très clair. »

---

## reset

**Q11 : Quand reset est dangereux ?**  
Réponse courte : `reset --hard` est dangereux dès que tu déplaces HEAD vers un commit antérieur : les changements des commits « passés » disparaissent des fichiers. Si tu n’as pas push et que tu connais le hash (ou reflog), tu peux récupérer.  
Réponse longue : Le danger : perdre du travail non commité ou oublier où était HEAD. --soft et --mixed ne détruisent pas le travail, ils le déplacent en staging ou working tree. --hard supprime l’état des fichiers au-delà du commit cible. Reflog garde les anciens HEAD.  
Clôture : « Le seul vraiment destructeur sur les fichiers, c’est --hard. Reflog limite la casse. »

**Q12 : Reset sur un commit déjà poussé ?**  
Réponse courte : En local, tu peux. Pour « annuler » sur le remote, il faudrait push --force, ce qui réécrit l’historique distant et pose les mêmes problèmes qu’amend/rebase après push. À éviter sans accord.  
Réponse longue : Reset local + force push fait disparaître des commits du serveur. Les autres devs qui ont ces commits auront un historique divergent. Procédure : communication, puis chacun reset ou rebase sa copie sur la nouvelle tête.  
Clôture : « Reset sur du déjà poussé = force push = à cadrer en équipe. »

**Q13 : Quelle est la différence entre revert et reset ?**  
Réponse courte : Revert crée un nouveau commit qui annule les effets d’un commit donné ; l’historique n’est pas réécrit. Reset déplace la branche ; il ne crée pas de commit. Revert = safe pour du déjà partagé ; reset = pour réécrire en local.  
Réponse longue : Revert prend un commit et produit le patch inverse, en nouveau commit. L’historique garde la trace de l’annulation. Reset change juste où pointe la branche ; les commits « après » ne sont plus sur la branche.  
Clôture : « Revert = annuler en ajoutant un commit. Reset = déplacer la branche. »

---

## cherry-pick

**Q14 : Cherry-pick pollue-t-il l’historique ?**  
Réponse courte : Il ajoute des commits (copies) sur ta branche. Si tu cherry-pick le même fix sur plusieurs branches, tu as des commits différents avec le même diff — ce n’est pas de la « pollution » en soi, mais ça duplique l’info.  
Réponse longue : Chaque cherry-pick crée un nouveau commit (nouveau hash, même contenu diff). Pour un même fix sur main et release, tu auras deux commits distincts. Certaines équipes préfèrent merge pour garder un lien explicite.  
Clôture : « Cherry-pick ajoute des commits ; c’est voulu. La "pollution" dépend de ta convention (merge vs cherry-pick). »

**Q15 : Cherry-pick plusieurs commits dans l’ordre ?**  
Réponse courte : Oui : `git cherry-pick A B C` applique A, puis B, puis C. L’ordre des arguments = ordre d’application. Si un conflit survient, tu résous, git add, git cherry-pick --continue.  
Réponse longue : Tu peux aussi utiliser une plage : `git cherry-pick A..B` (commits après A jusqu’à B inclus). Attention : A..B n’inclut pas A. Pour A et B inclus : `cherry-pick A^..B` ou lister les hash.  
Clôture : « Plusieurs commits : tu les listes dans l’ordre. »

---

## Avant push / PR

**Q16 : Que faire si quelqu’un a déjà pull ma branche ?**  
Réponse courte : Si tu as rebasé ou amendé après son pull, son historique et le tien divergent. Il doit soit `git fetch` puis `git reset --hard origin/ta-branche` (il perd ses commits locaux sur cette branche), soit rebaser son travail sur ta nouvelle tête.  
Réponse longue : La règle : celui qui a réécrit (toi) prévient. L’autre fait un fetch, regarde le log, et décide soit de repartir de origin/ta-branche, soit de rebaser ses commits par-dessus. Éviter le rebase après push sur une branche partagée limite ce cas.  
Clôture : « Dès que la branche est partagée, la réécriture se coordonne. »

**Q17 : Comment standardiser ça en équipe ?**  
Réponse courte : Définir des règles écrites : format des messages (conventionnel commits ou maison), « pas de force-push sur main », « rebase uniquement sur sa feature avant ouverture de PR », et éventuellement des hooks ou des checks en CI (message, nombre de commits par PR).  
Réponse longue : Doc courte (README ou CONTRIBUTING), revue de PR qui vérifie l’historique, options de merge (squash / merge) figées dans la plateforme (GitHub/GitLab). Les Tech Leads font appliquer la convention en review.  
Clôture : « Une page de règles Git + application en review, ça suffit pour standardiser. »

**Q18 : Quelles règles en entreprise ?**  
Réponse courte : Typiquement : main protégée (pas de push direct, pas de force), branches courtes et rebase avant PR, messages conventionnels, et choix squash vs merge commit pour les PR. Les règles dépendent du contexte (release, audit, multi-équipes).  
Réponse longue : Certaines boîtes imposent des templates de message, des validations CI sur l’historique, ou interdisent le rebase sur les branches de release. Le Tech Lead doit aligner les règles avec la conformité et le flux de release.  
Clôture : « Les règles viennent du besoin : lisibilité, traçabilité, conformité. »

**Q19 : Faut-il un commit par fichier ou par intention ?**  
Réponse courte : Par intention. Un commit = une modification logique (une feature, un fix, un refactor). Plusieurs fichiers peuvent aller dans le même commit s’ils servent la même intention.  
Réponse longue : Un commit par fichier peut fragmenter inutilement (ex. "add User" puis "fix User" alors que c’est le même changement). Par intention, la review et le bisect sont plus simples.  
Clôture : « Un commit = une intention. Les fichiers suivent. »

---

## Travail en équipe

**Q20 : Comment éviter que les gens push sans nettoyer ?**  
Réponse courte : Convention + review. En review, on regarde l’historique ; si c’est sale, on demande de rebaser/squash avant merge. Optionnel : pre-commit ou hook qui rappelle les bonnes pratiques, ou CI qui vérifie le format des messages.  
Réponse longue : La culture compte plus que les outils : le TL montre l’exemple et exige un historique propre en PR. Ensuite, hooks ou CI peuvent renforcer (message pattern, nombre max de commits).  
Clôture : « Convention claire + review exigeante. Les outils viennent en renfort. »

**Q21 : Merge vs rebase pour intégrer main dans ma feature ?**  
Réponse courte : Rebase : ta branche est rejouée sur la tête de main → historique linéaire. Merge : tu fusionnes main dans ta branche → commit de merge. Rebase garde un historique plus propre ; merge garde la trace exacte des intégrations.  
Réponse longue : Rebase « déplace » tes commits au-dessus de main ; tu réécris ta branche. Si tu as déjà poussé ta feature, rebase = force push. Beaucoup d’équipes font « merge main dans feature » pour éviter les force push, ou « rebase feature sur main » avant la PR uniquement en local.  
Clôture : « Rebase = plus propre, à faire avant push. Merge = plus safe une fois la branche partagée. »

**Q22 : Comment gérer les grosses features avec beaucoup de commits ?**  
Réponse courte : Travailler par petits commits en local, puis avant la PR faire un rebase -i pour squasher ou regrouper en quelques commits logiques. Ou ouvrir des PR intermédiaires (feature découpée).  
Réponse longue : Éviter les branches de 50 commits : soit tu découpes la feature en sous-branches/PR, soit tu nettoies en local avec rebase -i (squash par bloc logique) avant d’ouvrir une seule grosse PR.  
Clôture : « Beaucoup de commits : rebase -i pour regrouper, ou PR multiples. »

---

## Risques et erreurs

**Q23 : J’ai fait reset --hard sur le mauvais commit.**  
Réponse courte : `git reflog` : tu repères l’entrée où HEAD était au bon endroit (avant le reset). Puis `git reset --hard <hash>` pour revenir. Tes fichiers et ta branche reviennent à l’état d’avant.  
Réponse longue : Reflog garde les mouvements de HEAD. Chaque ligne a un hash (ex. abc1234). Tu copies ce hash et tu fais reset --hard abc1234. Aucune perte tant que l’entrée n’a pas été purgée (gc).  
Clôture : « Reflog, puis reset --hard sur le hash d’avant. »

**Q24 : J’ai amendé alors que j’avais déjà push.**  
Réponse courte : Si personne n’a tiré : `git push --force-with-lease`. Si quelqu’un a tiré : il faut le prévenir ; il fera un reset --hard sur origin/ta-branche après ton force push, ou rebasera son travail.  
Réponse longue : --force-with-lease est plus safe que --force : Git refuse de pousser si la branche distante a changé (quelqu’un a poussé entre-temps). Éviter d’amender après push sur une branche partagée reste la meilleure pratique.  
Clôture : « Après amend sur du déjà poussé : force-with-lease si tu es seul sur la branche ; sinon, coordination. »

**Q25 : Rebase -i : j’ai fermé l’éditeur sans sauvegarder.**  
Réponse courte : Selon l’éditeur : si tu as quitté sans sauver (ex. vim sans :wq), le rebase est souvent annulé ou Git te redemande. Si le rebase a commencé et que tu es perdu : `git rebase --abort` pour revenir à l’état d’avant.  
Réponse longue : En vim, :q! quitte sans sauver ; Git peut interpréter ça comme « annuler le rebase ». En cas de doute, reflog + reset --hard sur le hash d’avant le rebase remet tout.  
Clôture : « En cas de doute : rebase --abort ou reflog + reset. »

**Q26 : Comment récupérer un commit perdu ?**  
Réponse courte : `git reflog`. Tu trouves le hash du commit (ou de la branche) avant qu’il soit « perdu ». Puis `git checkout -b recuperation <hash>` ou `git reset --hard <hash>` selon ce que tu veux faire.  
Réponse longue : Les commits ne sont supprimés que quand ils ne sont plus référencés nulle part (branche, tag, reflog) et que git gc a tourné. Reflog référence HEAD pendant ~90 jours. Tu récupères en créant une branche sur ce hash ou en remettant la branche dessus.  
Clôture : « Reflog est ton filet de sécurité. Le commit est retrouvable tant qu’il est dans le reflog. »

**Q27 : Reflog est-il fiable ?**  
Réponse courte : Oui, en local. Les entrées sont supprimées après une durée (par défaut ~90 jours) ou par un garbage collect agressif. Reflog ne se pousse pas ; chaque clone a le sien.  
Réponse longue : Reflog est une liste locale des mouvements de références. Il n’est pas conçu comme une backup permanente : après un certain temps ou un `git gc --prune=now`, les commits orphelins peuvent être purgés. Pour du critique, backup du repo ou duplication des refs.  
Clôture : « Fiable pour récupérer une erreur récente. Pas une archive longue durée. »

---

## Récupération (reflog, sans exercice)

**Q28 : Quelqu’un a supprimé une branche par erreur.**  
Réponse courte : Si la branche a existé localement, `git reflog` sur sa machine peut encore contenir le hash de la dernière pointe de la branche. Créer une nouvelle branche sur ce hash : `git branch nom-branche <hash>`.  
Réponse longue : Reflog enregistre les anciennes valeurs des références. Donc « branch X pointait vers abc123 » reste visible. Sur le serveur, si la branche a été supprimée, il faut que le serveur ait un reflog (certaines hébergeurs le gardent) ou une autre copie du repo.  
Clôture : « Reflog local peut sauver la branche. Côté serveur, ça dépend de l’hébergeur. »

**Q29 : Je veux annuler un rebase en cours.**  
Réponse courte : `git rebase --abort`. Tu reviens à l’état du repo juste avant le `git rebase -i`.  
Réponse longue : Pendant un rebase, Git crée une branche temporaire. --abort supprime cette branche et remet HEAD et l’index comme avant. Si tu as déjà fini le rebase, c’est reflog + reset --hard sur l’ancien HEAD.  
Clôture : « En cours : rebase --abort. Déjà terminé : reflog. »

**Q30 : Peut-on récupérer après un git gc ?**  
Réponse courte : Une fois que gc a purgé les objets orphelins (non référencés par une ref ou le reflog), ils sont en principe perdus. En pratique, le reflog retarde la purge ; et certains outils de récupération de fichiers peuvent parfois retrouver des objets sur disque. Ne pas compter dessus.  
Réponse longue : git gc --prune=now supprime les objets inaccessibles. Les objets encore dans le reflog restent accessibles jusqu’à expiration du reflog. Sauvegardes et bonnes habitudes (ne pas gc agressif sans besoin) limitent le risque.  
Clôture : « Après une purge complète, la récupération n’est pas garantie. D’où l’importance du reflog avant toute opération destructive. »

**Q31 : Amend avec un mauvais message : on revient en arrière ?**  
Réponse courte : Tu peux amend encore une fois avec le bon message. Ou si tu veux retrouver l’ancien commit : reflog, repérer le hash avant le premier amend, puis `git reset --hard <hash>`.  
Réponse longue : Un seul niveau d’amend : refaire `git commit --amend -m "Bon message"`. Si tu as enchaîné plusieurs amends et que tu veux l’état d’il y a deux amends : reflog, trouver le hash correspondant, reset.  
Clôture : « Soit tu re-amend avec le bon message, soit tu reviens via reflog. »

**Q32 : Comment expliquer reflog à un dev junior ?**  
Réponse courte : « Git note chaque fois que ta branche ou HEAD change de commit. Cette liste, c’est le reflog. Si tu te trompes avec reset ou rebase, tu peux retrouver l’ancien endroit et y revenir. »  
Réponse longue : Montrer un `git reflog` après un amend ou un reset : l’ancien hash est encore là. Expliquer que « perdre un commit » = la branche ne pointe plus dessus, mais le commit existe encore jusqu’à ce qu’il soit purgé.  
Clôture : « Reflog, c’est l’historique des positions de HEAD. Ton filet de sécurité. »

---

Fin des questions anticipées.
