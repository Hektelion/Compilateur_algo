# 20 et 21 mai 2020

## Travail réalisé

### Lexer
Durant la première partie il a sagit de mettre au point
un lexer "infaillible" reprenant la lexique proposé dans le fichier :
[Sujet](./doc/StageL3-CompilationWeb.pdf)
 - commentaire d'une ligne -> "//" et "#"
 - chaine de caractères
 - mot-clé "Algorithme" + nom
 - mot-clé "Role" + description
 - mot-clé "Declaration" + declaration de variables
 - corps du programme + instruction
 - structure si alors + si alors sinon
 - structure pour + pour par pas
 - structure tant que

## Difficultés recontrées

### Lexer
 - mise au point de rêgles couvrant la totalité
 des besoins
 - l'utilisation de "mini-lexer"

## Travail à faire maintenant

### Lexer
Dans l'état actuel des choses le lexer est "brut" et "rigide"
il est possible de le simplifier en compressant des rêgles

-----------------------------

# 22 et 23 mai 2020

## Travail réalisé

### Lexer
Le lexer est bien trop complexe pour ce qui est necessaire
 - l'absorption d'espace et d'indentation est étendue a (algo, role, declaration, si, pour , tant que)
 - l'absorption de retour à la ligne est étendue a (declaration, si, pour , tant que)
 - la recherche d'opérateur booleen est étendue a (si, pour , tant que)
 - la recherche d'identifiant est étendue a (declaration, si, pour , tant que)

## Difficultés recontrées

### Lexer
 - trouver un critère de simplification de rêgles

## Travail à faire maintenant

### Lexer
Effectuer des tests pour verifier les différents éléments ajouté durant les 4 derniers jours

### Parser
Mettre au point la grammaire de l'analyseur syntaxique
ainsi qu'une première version de l'analyseur

-----------------------------

# 24 et 25 mai 2020

## Travail réalisé

### Lexer
 - Correction d'un problème sur la présence d'un opérateur arithmétique dans une condition de structure par :
    - l'extension de la recherche d'opérateur arithmétique a (si, pour , tant que)

### Parser
 - mise au point du parser
 - correction de bugs sur le parser

## Difficultés recontrées

### Lexer
 - la necessité de logs sur le lexer pour determiner une erreur d'analyse lexicale

### Parser
 - 2 conflit, décalage/réduction et réduction/réduction

## Travail à faire maintenant

### Parser
 - regler le problème d'ambiguité sur la grammaire du parser

 -----------------------------

# 26 mai 2020

## Travail réalisé

### Parser
 - retrait de l'ambiguïté sur la grammaire
 - ajout d'une table de hachage pour les variables

## Difficultés recontrées

### Parser
 - la déclaration multiple de variables pose un problème

## Travail à faire maintenant

### Parser
 - regler le probleme des declaration multiple

 -----------------------------

 # 27 mai 2020

## Travail réalisé

### Parser
 - ajout des entrées dans la table de hashage
 - clarification des logs du compilateur

## Difficultés recontrées

### Parser
 - 

## Travail à faire maintenant

### Parser
 - 

 -----------------------------