# Guide Cursor Pro pour Tech Lead — Atelier Git

Quand utiliser Cursor, quand ne pas l’utiliser, prompts utiles, limites. Cursor comme copilote, pas comme autorité.

---

## Quand utiliser Cursor pendant l’atelier

- **Rappels de syntaxe** : « Quelle est la syntaxe exacte de git rebase -i HEAD~3 ? »  
- **Comprendre une sortie** : coller un `git status` ou `git log` et demander « Explique cette sortie en une phrase. »  
- **Vérifier une commande** : « Est-ce que git reset --soft supprime des fichiers du working tree ? »  
- **Réviser une notion** : « Résume la différence entre reset --soft et --mixed. »

Cursor peut confirmer ou préciser ce que le formateur a dit. Il ne remplace pas la démo ni la pratique.

---

## Quand NE PAS utiliser Cursor pendant l’atelier

- **Pour exécuter les commandes à ta place.** Tu dois taper et voir la sortie toi-même.  
- **Pour décider à ta place** (ex. « Dois-je faire un squash ou un merge ? »). La décision dépend du contexte d’équipe ; Cursor peut expliquer les options, pas choisir pour toi.  
- **Pour remplacer la lecture du support.** Les slides et le script sont la source de vérité de la formation.  
- **En plein milieu d’un rebase -i.** L’éditeur ouvert, les actions (pick, squash, etc.) doivent rester sous ton contrôle ; pas de copier-coller aveugle depuis une réponse IA.

---

## Prompts utiles pendant l’atelier

- « Donne-moi les commandes pour : créer un repo, faire 3 commits, puis amender le dernier. »  
- « Que fait exactement git reset --mixed HEAD~1 ? »  
- « Explique en deux phrases ce qu’est le reflog et quand l’utiliser. »  
- « Quelle commande pour appliquer le commit abc123 sur ma branche actuelle ? »

Tu peux utiliser ces prompts pour vérifier ta compréhension ou préparer une démo.

---

## Prompts utiles en situation réelle de Tech Lead

- « Rédige une courte règle Git pour une équipe : pas de force-push sur main, messages conventionnels. »  
- « Un dev a fait un reset --hard par erreur. Donne les étapes de récupération avec reflog. »  
- « Compare squash vs merge commit pour une PR, en trois bullet points. »  
- « Écris un paragraphe pour un CONTRIBUTING : comment nettoyer l’historique avant une PR. »

Cursor peut t’aider à rédiger de la doc ou des procédures. Tu restes responsable du contenu et des choix d’équipe.

---

## Limites à expliquer aux apprenants

- **Cursor peut se tromper.** Les réponses sur Git sont en général fiables pour les commandes courantes, mais une vérification dans la doc officielle ou en exécutant la commande reste de rigueur pour les cas limites.  
- **Cursor ne connaît pas ton contexte.** Il ne sait pas si ta branche est partagée, si ton entreprise interdit le force-push, etc. Les décisions (rebase ou pas, squash ou merge) restent humaines.  
- **Cursor n’exécute pas Git.** Il ne peut pas faire un reflog à ta place ni récupérer un commit. Il peut seulement proposer des commandes à exécuter localement.  
- **Pas d’autorité.** En cas de contradiction entre Cursor et le formateur ou la doc Git, privilégier le formateur et la doc. Cursor est un outil d’aide, pas la référence.

---

## Positionner Cursor : copilote, pas autorité

En formation, tu peux dire :  
« Cursor est un copilote : il peut te rappeler une commande, t’expliquer une sortie, ou t’aider à rédiger une règle. Il ne remplace pas ta main sur le clavier ni ta décision en équipe. Tu restes responsable de ce que tu exécutes et de ce que tu adoptes comme convention. »

En situation réelle de Tech Lead :  
Utiliser Cursor pour accélérer la rédaction de standards, les FAQ Git, ou les procédures de récupération. Les valider avant de les diffuser. Ne pas déléguer les choix d’équipe (workflow, protection des branches) à l’IA.
