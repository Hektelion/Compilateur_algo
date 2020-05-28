%{

#include <stdlib.h>
#include <stdio.h>
#include <include.h>

typedef struct Variable {
	char *type;
	void *value;
}Variable;

void init();
void cleanup();

int yyerror(const char *msg);

extern int nb_line;
char *msg;

char *type;

GHashTable* var_hash_table;

Variable *var;

%}

/* typage des tokens */

%union {
	int entier;
	float reel;
	int booleen;
	char caractere;
    char *chaine;
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

%token <chaine>		TOK_ALGO
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

%token <entier>		TOK_INT
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

%token <chaine>		TOK_ID

%start				algorithme

%%

/* Regle */

algorithme	: algo_definition algo_role declaration debut programme fin {
				printf(" <algorithme> \t -> \t Algorithme : OK\n");
			}
          	;

algo_definition: TOK_ALGO TOK_ALGO_NAME {  }
               | TOK_ALGO               {  }
               | %empty                 {  }
               ;

algo_role: TOK_ROLE TOK_COMMA TOK_ROLE_DESC {  }
         | TOK_ROLE TOK_COMMA               {  }
		 | TOK_ROLE TOK_ROLE_DESC           {  }
         | TOK_ROLE                         {  }
         | %empty                           {  }
         ;

declaration : TOK_DECLARE declaration {
				printf("Fin declaration\n");
				//printf("%s\n", $2);
		   	}
		   	| TOK_ID TOK_COMMA TOK_TYPE declaration {
				var = malloc(sizeof(Variable));
				if(var == NULL) {
					perror("malloc");
					exit(EXIT_FAILURE);
				}

				type = strdup($3); //LES VARIABLES UTILISE LA MEME ADRESSE POUR LE TYPE DANS LA TABLE DE HASHAGE
				var->type = type;

				if(g_hash_table_insert(var_hash_table, strdup($1), var)) {
					printf("\tdeclaration de %s réussi\n", $1);					
				}
				else {
					fprintf(stderr, "ERREUR : la declaration de la varialbe %s a échouée\n", $1);
				}
		   	}
           	| TOK_ID TOK_COLON declaration {
				var = malloc(sizeof(Variable));
				if(var == NULL) {
					perror("malloc");
					exit(EXIT_FAILURE);
				}

				var->type = type;

				if(g_hash_table_insert(var_hash_table, strdup($1), var)) {
					printf("\tdeclaration de %s réussi\n", $1);		
				}
				else {
					fprintf(stderr, "ERREUR : la declaration de la varialbe %s a échouée\n", $1);
				}
		   	}
           	| %empty { printf("Debut declaration\n"); }
           	;

debut: TOK_BEGIN { printf("Debut du programme\n"); }
     ;

fin: TOK_END { printf("Fin du programme\n"); }
   ;

programme: bloc_instruction {  }
         ;

bloc_instruction: instruction bloc_instruction {  }
				| structure_conditionnelle bloc_instruction {  }	
				| structure_iterative bloc_instruction {  }
				| %empty {  }
				;

instruction: TOK_ID TOK_PARL arguments TOK_PARR {  }
		   | TOK_ID TOK_EQUAL expression {  }
		   ;

expression: operande {  }
		  | operande TOK_OP expression {  }
		  | TOK_PARL expression TOK_PARR {  }
		  ;

arguments: argument TOK_COMMA arguments {  }
		 | argument {  }
		 ;

argument: TOK_STRING {  }
		| TOK_ID {  }
		| TOK_INT {  }
		| TOK_FLOAT {  }
		| TOK_CHAR {  }
		| TOK_BOOL {  }
		;

operande: TOK_ID {  }
		| TOK_INT {  }
		| TOK_FLOAT {  }
		| TOK_CHAR {  }
		| TOK_BOOL {  }
		;

structure_conditionnelle: TOK_IF expression TOK_THEN bloc_instruction TOK_EIF {  }
						| TOK_IF expression TOK_THEN bloc_instruction TOK_ELSE bloc_instruction TOK_EIF {  }
						;

structure_iterative: TOK_FOR TOK_ID TOK_FROM operande TOK_TO operande TOK_DO bloc_instruction TOK_EFOR {  }
				   | TOK_FOR TOK_ID TOK_FROM operande TOK_TO operande TOK_BY_STEP operande TOK_DO bloc_instruction TOK_EFOR {  }
				   | TOK_WHILE expression TOK_DO bloc_instruction TOK_EWHILE {  }
				   ;

%%

int main (int argc, char* argv[]) {
	
	init();

    yyparse();

	cleanup();

	return EXIT_SUCCESS;
}

void init() {
	if( (var_hash_table = g_hash_table_new(g_str_hash, g_str_equal)) == NULL )
		perror("g_hash_table_new");
	else
		printf("Table de hachage crée avec succes\n");
}

void cleanup() {
	g_hash_table_destroy(var_hash_table);
}

int yyerror (const char *msg) {
    fprintf(stderr, "ERREUR(%d) : %s\n", nb_line, msg);
}