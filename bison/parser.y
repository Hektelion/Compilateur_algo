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

%type <chaine>		algorithme

%type <chaine>		algo_definition
%type <chaine>		algo_role
%type <chaine>		declaration

%type <chaine>		bloc_instruction
%type <chaine>		instruction

%type <chaine>		expression

%type <chaine>		arguments
%type <chaine>		argument

%type <chaine>		operande

%type <chaine>		structure_conditionnelle
%type <chaine>		structure_iterative

/* token */

%token <chaine>			TOK_ALGO
%token <chaine>		TOK_ALGO_NAME

%token <chaine>		TOK_ROLE
%token <chaine>		TOK_ROLE_DESC

%token <chaine>		TOK_DECLARE

%token <chaine>		TOK_BEGIN
%token <chaine>		TOK_END

%token <chaine>		TOK_TYPE

%token <chaine>		TOK_IF
%token <chaine>		TOK_ELSE
%token <chaine>		TOK_THEN
%token <chaine>		TOK_EIF

%token <chaine>		TOK_FOR
%token <chaine>		TOK_FROM
%token <chaine>		TOK_TO
%token <chaine>		TOK_BY_STEP
%token <chaine>		TOK_DO
%token <chaine>		TOK_EFOR

%token <chaine>		TOK_WHILE
%token <chaine>		TOK_EWHILE

%token <nombre>		TOK_INT
%token <chaine>		TOK_FLOAT
%token <chaine>		TOK_CHAR
%token <chaine>		TOK_BOOL
%token <chaine>		TOK_STRING

%token <chaine>		TOK_OP
%token <chaine>		TOK_EQUAL

%token <chaine> 	TOK_PARL
%token <chaine>		TOK_PARR
%token <chaine> 	TOK_COLON
%token <chaine>		TOK_COMMA
%token <chaine>		TOK_QUOTE

%token <chaine>		TOK_ID

%start				algorithme

%%

/* Regle */

algorithme: algo_definition algo_role declaration debut programme fin { printf(" <algorithme> \t -> \t Algorithme : OK\n"); }
          ;

algo_definition: TOK_ALGO TOK_ALGO_NAME { printf(" <algo_definition> \t -> \t %s %s\n", $1, $2); }
               | TOK_ALGO               { printf(" <algo_definition> \t -> \t %s\n", $1);  }
               | %empty                 { printf(" <algo_definition> \t -> \t algo_definition : [EMPTY]\n"); }
               ;

algo_role: TOK_ROLE TOK_COMMA TOK_ROLE_DESC { printf(" <algo_role> \t -> \t %s : %s\n", $1, $3);  }
         | TOK_ROLE TOK_COMMA               { printf(" <algo_role> \t -> \t %s :\n", $1); }
		 | TOK_ROLE TOK_ROLE_DESC           { printf(" <algo_role> \t -> \t %s %s\n", $1, $2); }
         | TOK_ROLE                         { printf(" <algo_role> \t -> \t %s\n",$1); }
         | %empty                           { printf(" <algo_role> \t -> \t algo_role : [EMPTY]\n"); }
         ;

declaration: TOK_DECLARE declaration            	{ printf(" <declaration> \t -> \t %s <declaration>\n", $1); }
           | TOK_ID TOK_COLON declaration  			{ printf(" <declaration> \t -> \t %s %s <declaration>\n", $1, $2); }
		   | TOK_ID TOK_COMMA TOK_TYPE declaration	{ printf(" <declaration> \t -> \t %s %s %s <declaration>\n", $1, $2, $3); }
           | %empty                             	{ printf(" <declaration> \t -> \t declaration : [EMPTY]\n"); }
           ;

debut: TOK_BEGIN { printf(" <debut> \t -> \t %s\n", $1); }
     ;

fin: TOK_END { printf(" <fin> \t -> \t %s\n", $1); }
   ;

programme: bloc_instruction { printf(" <programme> \t -> \t <bloc_instruction>\n"); }
         ;

bloc_instruction: instruction bloc_instruction { printf(" <bloc_instruction> \t -> \t <instruction> <bloc_instruction>\n"); }
				| structure_conditionnelle bloc_instruction { printf(" <bloc_instruction> \t -> \t <structure_conditionnelle> <bloc_instruction>\n");  }	
				| structure_iterative bloc_instruction { printf(" <bloc_instruction> \t -> \t <structure_iterative> <bloc_instruction>\n");  }
				| %empty { printf(" <bloc_instruction> \t -> \t bloc_instruction : [EMPTY]\n"); }
				;

instruction: TOK_ID TOK_PARL arguments TOK_PARR { printf(" <instruction> \t -> \t %s %s <arguments> %s\n", $1, $2, $4); }
		   | TOK_ID TOK_EQUAL expression { printf(" <instruction> \t -> \t %s %s <expression>\n", $1, $2); }
		   ;

expression: operande { printf(" <expression> \t -> \t <operande>\n"); }
		  | operande TOK_OP expression { printf(" <expression> \t -> \t <operande> %s <expression>\n", $2); }
		  | TOK_PARL expression TOK_PARR { printf(" <expression> \t -> \t %s <expression> %s\n", $1, $3); }
		  ;

arguments: argument TOK_COMMA arguments { printf(" <arguments> \t -> \t <argument> %s <arguments>\n", $2); }
		 | argument { printf(" <arguments> \t -> \t <argument>\n"); }
		 ;

argument: TOK_STRING { printf(" <argument> \t -> \t %s\n", $1); }
		| TOK_ID { printf(" <argument> \t -> \t %s\n", $1); }
		;

operande: TOK_ID { printf(" <operande> \t -> \t %s\n", $1); }
		| TOK_INT { printf(" <operande> \t -> \t %d\n", $1); }
		;

structure_conditionnelle: TOK_IF expression TOK_THEN bloc_instruction TOK_EIF { printf(" <structure_conditionnelle> \t -> \t %s <expression> %s <bloc_instruction> %s\n", $1, $3, $5); }
						| TOK_IF expression TOK_THEN bloc_instruction TOK_ELSE bloc_instruction TOK_EIF { printf(" <structure_conditionnelle> \t -> \t %s <expression> %s <bloc_instruction> %s <bloc_instruction> %s\n", $1, $3, $5, $7); }
						;

structure_iterative: TOK_FOR TOK_ID TOK_FROM operande TOK_TO operande TOK_DO bloc_instruction TOK_EFOR { printf(" <structure_iterative> \t -> \t %s %s %s <operande> %s <operande> %s <bloc_instruction> %s\n", $1, $2, $3, $5, $7, $9); }
				   | TOK_FOR TOK_ID TOK_FROM operande TOK_TO operande TOK_BY_STEP operande TOK_DO bloc_instruction TOK_EFOR { printf(" <structure_iterative> \t -> \t %s %s %s <operande> %s <operande> %s <operande> %s <bloc_instruction> %s\n", $1, $2, $3, $5, $7, $9, $11); }
				   | TOK_WHILE expression TOK_DO bloc_instruction TOK_EWHILE { printf(" <structure_iterative> \t -> \t %s <expression> %s <bloc_instruction> %s\n", $1, $3, $5); }
				   ;

%%

int yyerror (const char *msg) {
    fprintf(stderr, "ERREUR(%d) : %s\n", nb_line, msg);
}

int main (int argc, char* argv[]) {
    yyparse();
}