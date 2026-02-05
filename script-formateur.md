# Script formateur — Git : historique propre avant PR

Public : Tech Leads. Environnement : Git local uniquement. Aucune mention de durée en séance.

---

## Accueil et cadre

**Tu dis :**  
« Bonjour. On va travailler sur un sujet précis : comment avoir un historique Git propre avant d’ouvrir une PR ou de pousser. On reste en local, pas de conflits. Tu repartiras avec des réflexes utilisables tout de suite. »

**Tu affiches la slide 1 (titre).**

**Tu dis :**  
« L’objectif de cette session : tu repartiras avec des réflexes précis pour nettoyer ton historique local avant de pousser ou d’ouvrir une PR. On reste en local, pas de conflits. »

**Transition :**  
« Pour ça, on s’appuie sur un modèle mental simple : les trois zones. »

---

## Les trois zones (working tree, staging, history)

**Tu affiches la slide 2 (schéma des trois zones).**

**Tu dis :**  
« Avant d’attaquer amend ou reset, on fixe le modèle mental : working tree, staging, history. Chaque fichier est soit dans le répertoire de travail, soit dans l’index — le staging — soit figé dans un commit. »

**Tu pointes le schéma :**  
« add fait passer du working tree au staging. commit fait passer du staging à l’history. Les commits sont immutables… tant qu’on ne réécrit pas l’historique. On verra ça avec amend et rebase. »

**Tu dis :**  
« Question : est-ce que tout le monde a déjà utilisé git add et git commit au quotidien ? »  
[Tu laisses une main se lever ou un signe.]  
« Parfait. On ne revient pas sur le B-A-BA, mais si un terme te paraît flou, tu lèves la main. »

**Tu affiches la slide 3 (git status / git log).**

**Lecture du schéma (slide 3) :**  
En haut, un petit schéma rappelle que « git status » lit Working tree + Staging, et « git log » lit History. Deux zones, deux commandes. Tu peux le montrer en une phrase : « status = ce qui bouge, log = ce qui est déjà figé. »

**Tu dis :**  
« Pour savoir où tu en es, deux commandes : git status et git log. Status te dit ce qui est modifié, stagé ou non, et les fichiers non suivis. Log te montre l’historique des commits. Tu dois pouvoir interpréter ces deux sorties en deux secondes. »

**Tu lis à voix haute les faux outputs.**  
« Ici : un fichier stagé, un modifié non stagé, un non suivi. Et en dessous, la chaîne de commits avec HEAD sur main. »

**Transition :**  
« Pourquoi s’embêter à nettoyer tout ça ? »

---

## Pourquoi nettoyer avant la PR

**Tu affiches la slide 4.**

**Tu dis :**  
« Une PR avec 12 commits dont 6 "fix", 3 "wip" et 2 typos, ça coûte du temps à tout le monde. Un historique propre sert à trois choses : la review — un commit = une intention ; le bisect — Git peut retrouver le commit qui a cassé un test ; et la convention d’équipe — un historique lisible devient la norme. »

**Tu dis :**  
« Règle importante : on nettoie en local, avant le push. Une fois poussé, on évite de réécrire sans accord, parce que ça impacte ceux qui ont déjà tiré la branche. »

**Transition :**  
« Premier outil concret : modifier le dernier commit. »

---

## commit --amend

**Tu affiches la slide 5.**

**Lecture du schéma (slide 5) :**  
Deux colonnes : « Avant » avec A puis B (HEAD). Flèche « --amend ». « Après » avec A puis B' (HEAD), et en bas « B disparaît de la branche (reste en reflog) ». Montre que seul le dernier commit change de hash et que la branche pointe sur le nouveau.

**Tu dis :**  
« Amend, c’est "le dernier commit ne me convient pas, je le refais en un seul bloc". Tu peux ajouter des fichiers oubliés, ou changer le message. La commande : git add si tu as des fichiers à ajouter, puis git commit --amend --no-edit pour garder le message, ou git commit --amend -m "Nouveau message" pour le changer. »

**Tu affiches la slide 6 (schéma amend détaillé).**

**Lecture du schéma (slide 6) :**  
Deux blocs « Avant amend » / « Après amend ». À gauche : A (abc123), B (def456), « main → B, HEAD → B ». Flèche « amend ». À droite : A inchangé, B' (xyz789, nouveau hash), « main → B', HEAD → B' », et « def456 orphelin (toujours en reflog) ». Pointe le passage de B à B', puis la ligne reflog pour insister sur le filet de sécurité.

**Tu dis :**  
« Ce qui se passe : le commit est remplacé. Le hash change. L’ancien commit n’est plus référencé par la branche, mais il existe encore un temps dans le reflog. C’est ton filet de sécurité. »

**Question à la salle :**  
« Quelqu’un a déjà amendé un commit puis poussé ? »  
[Réponse courte.]  
« Si d’autres ont déjà tiré cette branche, amend + push force une réécriture chez eux. D’où la règle : amend en local, avant le premier push de la branche, c’est sans risque. »

**Transition :**  
« Quand tu as plusieurs commits à retravailler, tu passes au rebase interactif. »

---

## rebase interactif

**Tu affiches la slide 7.**

**Tu dis :**  
« Rebase -i, c’est le couteau suisse pour "ces N derniers commits, je veux les retravailler". Tu lances git rebase -i HEAD~3 par exemple. L’éditeur s’ouvre avec la liste des commits et des actions : pick, reword, squash, drop. »

**Tu détailles :**  
« reword : tu changes uniquement le message. squash : tu fusionnes le commit avec le précédent ; à la fin tu édites un seul message. drop : tu supprimes le commit et ses changements. »

**Tu affiches la slide 8 (avant / après rebase -i).**

**Tu dis :**  
« Avant : A, B, C. Après un squash de B et C : A et un seul commit B'+C'. Les anciens B et C ne sont plus sur la branche ; ils restent un temps en reflog. »

**Démo (optionnel) :**  
« Je peux faire une démo rapide dans un repo de démo : créer deux commits, lancer rebase -i HEAD~2, squash, et montrer le log avant/après. »  
[Tu exécutes les commandes et commentes à voix haute.]

**Transition :**  
« Parfois tu veux juste "revenir en arrière" sans perdre le code. Là, c’est reset. »

---

## reset (soft, mixed, hard)

**Tu affiches la slide 9.**

**Lecture du schéma (slide 9) :**  
Trois boîtes côte à côte : « --soft » (changements → staging, aucune perte), « --mixed » (changements → working tree, défaut), « --hard » (changements supprimés des fichiers, reflog pour récupérer). Montre que la seule question est : où vont les changements des commits « dépassés ».

**Tu dis :**  
« Reset ne supprime pas les commits de l’univers : il décroche la branche et la recroche sur un commit donné. La différence entre soft, mixed et hard : où vont les changements. »

**Tu lis les trois points.**  
« Soft : tout reste en staging, tu peux recommitter proprement. Mixed : les changements se retrouvent en working tree, pas en staging. Hard : working tree et staging sont alignés sur le commit cible ; les changements des commits "passés" ne sont plus dans tes fichiers. Ils restent en reflog. »

**Tu affiches la slide 10 (schéma reset détaillé).**

**Lecture du schéma (slide 10) :**  
À gauche « État initial : HEAD sur C » (A, B, C). Puis quatre colonnes : initial, --soft (HEAD sur A, B+C en staging), --mixed (HEAD sur A, B+C en working tree), --hard (HEAD sur A, B+C supprimés des fichiers, reflog pour récupérer). En bas : « La branche pointe toujours sur A ; la différence = où sont les changements de B et C ». Pointe chaque colonne puis la phrase du bas.

**Tu pointes chaque colonne.**  
« Voilà l’effet. --hard est le seul qui fait "disparaître" les changements des fichiers. D’où la prudence : toujours vérifier le commit cible. Et en cas d’erreur, reflog. »

**Transition :**  
« Dernier outil rapide : cherry-pick, puis on parle du filet de sécurité. »

---

## cherry-pick et reflog

**Tu affiches la slide 11.**

**Tu dis :**  
« Cherry-pick, c’est "je veux ce commit ici, pas toute l’histoire". Tu appliques le diff d’un commit sur ta branche courante ; Git crée un nouveau commit. Utile pour ramener un fix d’une branche à l’autre. Limite : si le contexte a changé, tu peux avoir des conflits ; on ne les traite pas aujourd’hui. »

**Tu affiches la slide 12.**

**Tu dis :**  
« Reflog : Git enregistre où HEAD a pointé. Même après un reset --hard ou un rebase, les anciens commits restent repérables. git reflog te donne les hash ; si tu t’es trompé, git reset --hard abc1234 te remet où tu étais. Les entrées expirent après un moment — par défaut environ 90 jours. Reflog est local, il ne se pousse pas. »

**Transition :**  
« On enchaîne tout ça dans un workflow typique. »

---

## Workflow avant PR et récap

**Tu affiches la slide 13.**

**Lecture du schéma (slide 13) :**  
Un flowchart : Travailler → log -n 10 → décision « Dernier seul ? → amend » / « Plusieurs ? → rebase -i », et « Tout en un bloc ? → reset --soft », puis « log --graph » et « push / PR ». En bas en rouge : « Règle d’or : pas de réécriture après push sans accord ». Suis le flux du doigt puis insiste sur la règle du bas.

**Tu dis :**  
« Workflow typique : tu travailles, tu commites. Avant le push, tu fais un git log --oneline pour voir l’historique. Dernier commit à corriger seul → amend. Plusieurs à fusionner ou renommer → rebase -i. Tu veux tout remettre en un bloc et recommitter → reset --soft sur le commit de base, puis tu refais tes commits. À la fin, tu revérifies avec git log --oneline --graph. La règle d’or : tant que tu n’as pas push, tu peux réécrire sans impact pour les autres. »

**Tu affiches la slide 14 (récap commandes).**

**Tu dis :**  
« Récap des commandes qu’on a vues. Tu as le support ; tu peux t’y référer. »

**Reprise d’attention :**  
« On enchaîne sur le lab. Tout le monde a un terminal et Git sous la main ? »

---

## Lab — consignes

**Tu affiches la slide 15 (Atelier — Objectif).**

**Tu dis :**  
« On va créer un repo local, générer un historique volontairement sale, puis le nettoyer avec amend, rebase -i et éventuellement reset. Aucun conflit, fichiers simples. Tu vas reproduire les commandes sur ta machine. Si tu es bloqué, on fait un point après chaque étape. »

**Tu indiques les slides suivantes.**  
« Les étapes de l’atelier sont dans les slides : une slide par étape avec les commandes exactes. Tu peux aussi utiliser le script creer-depot-atelier pour obtenir directement un repo avec l’historique sale, puis enchaîner sur les étapes de nettoyage. Je passe entre les rangées pour les questions. »

---

## Lab pratique (participants)

Tu circules. Tu réponds aux questions en restant bref. Si quelqu’un est bloqué sur l’éditeur de rebase -i, tu rappelles : « Sauvegarde et quitte avec :wq sous vim, ou ferme l’onglet sous VS Code. » Tu ne fais pas le lab à leur place ; tu guides.

**Quand la plupart ont avancé :**  
« Derniers instants pour finir la dernière étape. On fera un debrief rapide ensuite. »

---

## Debrief et clôture

**Tu dis :**  
« Qui a pu aller au bout du lab ? Qui a bloqué sur une étape ? »  
[Tu prends une ou deux réponses courtes.]

**Tu affiches la slide 22 (Suite et ressources).**

**Tu dis :**  
« Tu as maintenant les outils pour garder un historique propre avant chaque PR. En équipe, définis des règles simples : format des messages, granularité des commits, pas de rebase après push sans accord. Les questions difficiles sont dans le doc "Questions anticipées". Tu peux t’y référer après la session. »

**Tu listes les fichiers du support.**  
« Merci pour ta concentration. Bonne continuation. »

---

## Notes formateur

- Les slides sont numérotées 1 à 22. Les slides 15 à 21 sont l’atelier (objectif + étapes 1 à 6). La slide 22 est la clôture.
- Questions : si une question sort du scope (conflits, merge vs rebase en remote), répondre en une phrase et proposer de la traiter après ou en asynchrone.
- Ton : calme, affirmé. Pas de « je pense que » ; dire « Git fait ceci » ou « la règle est celle-là ».

**Index des schémas (pour t’y retrouver) :**
- Slide 2 : trois zones (working tree → staging → history) avec flèches add / commit.
- Slide 3 : status lit WT+staging, log lit history.
- Slide 4 : historique sale (rouge) vs propre (vert), flèche « nettoyer ».
- Slide 5 : avant amend (A-B HEAD) → après (A-B' HEAD), reflog.
- Slide 6 : amend détaillé avec hash (abc123, def456, xyz789), orphelin reflog.
- Slide 7 : éditeur rebase -i (pick, reword, squash, drop).
- Slide 8 : avant A-B-C → après A et B'+C' (squash), orphelins reflog.
- Slide 9 : trois boîtes soft / mixed / hard (où vont les changements).
- Slide 10 : quatre colonnes (initial, --soft, --mixed, --hard) avec staging / working / supprimés.
- Slide 11 : branche feature (commit X) → cherry-pick → main (commit X').
- Slide 12 : sortie reflog (hash + description), récupération avec reset --hard.
- Slide 13 : flowchart travail → log → amend / rebase -i / reset --soft → log --graph → push, règle d’or.
