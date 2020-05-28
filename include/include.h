#ifndef INCLUDE_H
#define INCLUDE_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <glib.h>
#include <parser.tab.h>
int yylex (void);
int yyerror (const char *msg);

#define VIDE        0

#define ALGORITHME  1

#define DECLARATION 2
#define BLOC		3

#define INSTRUCTION 4
#define AFFECTATION 5

#define IF          6
#define IF_ELSE     7

#define FOR         8
#define FOR_BY_STEP 9
#define WHILE       10

#define ARGUMENTS   11
#define ARGUMENT    12

#define ARG_STRING  13

#define OPERANDE    14
#define EXPRESSION  15
#define EXPRESSION_PAR  16

#define ID          17
#define ENTIER      18
#define REEL        19
#define CARACTERE   20
#define BOOLEEN     21

#endif  