%{

#include <stdlib.h>
#include <stdio.h>
#include <include.h>

char *msg;

extern int nb_line;
%}

/* typage des tokens */

%union {
    char *chaine;
	int nombre;
}

%define parse.error verbose

/* non terminaux */

%type <chaine>          algorithme

%type <chaine>          algo_definition
%type <chaine>          algo_role
%type <chaine>          declaration
%type <chaine>          declaration_variable

%type <chaine>          bloc_instruction
%type <chaine>          instruction

%type <chaine>          expression

%type <chaine>          arguments
%type <chaine>          argument

%type <chaine>          operande

%type <chaine>          structure_conditionnelle
%type <chaine>          structure_iterative

/* token */

%token                  TOK_ALGO
%token                  TOK_ALGO_NAME

%token                  TOK_ROLE
%token                  TOK_ROLE_DESC

%token                  TOK_DECLARE

%token                  TOK_BEGIN
%token                  TOK_END

%token                  TOK_TYPE

%token					TOK_IF
%token					TOK_ELSE
%token					TOK_THEN
%token					TOK_EIF

%token					TOK_FOR
%token					TOK_FROM
%token					TOK_TO
%token					TOK_BY_STEP
%token					TOK_DO
%token					TOK_EFOR

%token					TOK_WHILE
%token					TOK_EWHILE

%token <nombre>			TOK_INT
%token					TOK_FLOAT
%token					TOK_CHAR
%token					TOK_BOOL
%token					TOK_STRING

%token <chaine>			TOK_OP
%token					TOK_EQUAL

%token					TOK_PARL
%token					TOK_PARR
%token					TOK_COLON
%token					TOK_COMMA
%token					TOK_QUOTE

%token <chaine>			TOK_ID

%start                  algorithme

%%

/* Regle */

algorithme: algo_definition algo_role declaration debut programme fin { printf("Algorithme : OK\n"); }
          ;

algo_definition: TOK_ALGO TOK_ALGO_NAME { printf("Algorithme definition avec nom : OK\n"); }
               | TOK_ALGO               { printf("Algorithme definition sans nom : OK\n"); }
               | %empty                 {  }
               ;

algo_role: TOK_ROLE TOK_COMMA TOK_ROLE_DESC { printf("Role avec description : OK\n"); }
         | TOK_ROLE TOK_COMMA               { printf("\tRole sans description avec comma : OK\n"); }
		 | TOK_ROLE TOK_ROLE_DESC           { printf("\tRole avec description sans comma : OK\n"); }
         | TOK_ROLE                         { printf("\tRole sans description : OK\n"); }
         | %empty                           {  }
         ;

declaration: TOK_DECLARE declaration            { printf("\tDeclaration : OK\n"); }
           | declaration declaration_variable   { printf("\tDeclaration variable : OK\n"); }
           | %empty                             {  }
           ;

declaration_variable: TOK_ID TOK_COMMA TOK_TYPE { printf("\tDeclaration variable : OK\n"); }
					| TOK_ID TOK_COLON declaration_variable { printf("\tDeclaration multiple de variables : OK\n"); }
                    ;

debut: TOK_BEGIN { printf("Debut : OK\n"); }
     ;

fin: TOK_END 	{ printf("Fin : OK\n"); }
   ;

programme: bloc_instruction {  }
		 | %empty {  }
         ;

bloc_instruction: instruction bloc_instruction {  }
				| structure_conditionnelle bloc_instruction {  }	
				| structure_iterative bloc_instruction {  }
				| %empty { printf("\tbloc d'instruction : OK\n"); }
				;

instruction: TOK_ID TOK_PARL arguments TOK_PARR { printf("\tInstruction : OK\n"); }
		   | TOK_ID TOK_EQUAL expression { printf("\tAffectation : OK\n"); }
		   ;

expression: operande {  }
		  | operande TOK_OP expression { printf("\t\topérateur %s : OK\n", $2); }
		  | TOK_PARL expression TOK_PARR {  }
		  ;

arguments: argument TOK_COMMA arguments {  }
		 | argument {  }
		 ;

argument: TOK_STRING {  }
		| TOK_ID {  }
		;

operande: TOK_ID { printf("\t\topérande variable %s : OK\n", $1); }
		| TOK_INT { printf("\t\topérande nombre %d : OK\n", $1); }
		;

structure_conditionnelle: TOK_IF expression TOK_THEN bloc_instruction TOK_EIF { printf("\tStructure conditionnelle si : OK\n"); }
						| TOK_IF expression TOK_THEN bloc_instruction TOK_ELSE bloc_instruction TOK_EIF { printf("\tStructure conditionnelle si sinon : OK\n"); }
						;

structure_iterative: TOK_FOR TOK_ID TOK_FROM operande TOK_TO operande TOK_DO bloc_instruction TOK_EFOR { printf("\tStructure itérative pour itérateur %s : OK\n", $2); }
				   | TOK_FOR TOK_ID TOK_FROM operande TOK_TO operande TOK_BY_STEP operande TOK_DO bloc_instruction TOK_EFOR { printf("\tStructure itérative pour avec pas itérateur %s : OK\n", $2); }
				   | TOK_WHILE expression TOK_DO bloc_instruction TOK_EWHILE { printf("\tStructure itérative tant que : OK\n"); }
				   ;

%%

int yyerror (const char *msg) {
    fprintf(stderr, "ERREUR(%d) : %s\n", nb_line, msg);
}

int main (int argc, char* argv[]) {
    yyparse();
}