%{

#include <stdlib.h>
#include <stdio.h>
#include <include.h>
#include <generator.h>

typedef struct Variable {
	char *type;
	GNode *value;
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

	GNode *noeud;
}

%define parse.error verbose

/* non terminaux */

%type <noeud>		algorithme

%type <noeud>		algo_definition
%type <noeud>		algo_role
%type <noeud>		declaration

%type <noeud>		bloc_instruction
%type <noeud>		instruction

%type <noeud>		expression

%type <noeud>		arguments
%type <noeud>		argument

%type <noeud>		operande

%type <noeud>		structure_conditionnelle
%type <noeud>		structure_iterative

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

%token <chaine>		TOK_INT
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

algorithme	: algo_definition algo_role declaration debut bloc_instruction fin {
				//printf(" <algorithme> \t -> \t Algorithme : OK\n");
				$$ = g_node_new((gpointer)ALGORITHME);
				g_node_append($$, $3); //Partie declaration
				g_node_append($$, $5); //Partie programme
				gen_code($$);
				g_node_destroy($$);
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
				//printf("Fin declaration\n");
				$$ = $2; //Passage de la partie declaration
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
					//printf("\tdeclaration de %s réussi\n", $1);					
				}
				else {
					fprintf(stderr, "ERREUR : la declaration de la varialbe %s a échouée\n", $1);
				}

				$$ = g_node_new((gpointer)DECLARATION);
				g_node_append_data($$, $1); //Identifiant de la variable
				g_node_append_data($$, $3); //Type de la variable
				g_node_append($$, $4); //Suite des declaration
		   	}
           	| TOK_ID TOK_COLON declaration {
				var = malloc(sizeof(Variable));
				if(var == NULL) {
					perror("malloc");
					exit(EXIT_FAILURE);
				}

				var->type = type;

				if(g_hash_table_insert(var_hash_table, strdup($1), var)) {
					//printf("\tdeclaration de %s réussi\n", $1);		
				}
				else {
					fprintf(stderr, "ERREUR : la declaration de la varialbe %s a échouée\n", $1);
				}
				$$ = g_node_new((gpointer)DECLARATION);
				g_node_append_data($$, $1); //Identifiant de la variable
				g_node_append_data($$, type); //Type de la variable
				g_node_append($$, $3); //Suite des declaration
		   	}
           	| %empty {
				   //printf("Debut declaration\n");
				   $$ = g_node_new((gpointer)VIDE);
			}
           	;

debut	: TOK_BEGIN {
			//printf("Debut du programme\n");
		}
     	;

fin	: TOK_END {
		//printf("Fin du programme\n");
	}
   	;

bloc_instruction: instruction bloc_instruction {
					$$ = g_node_new((gpointer)BLOC);
					g_node_append($$, $1); //L'instruction
					g_node_append($$, $2); //La suite des instructions
				}
				| structure_conditionnelle bloc_instruction {
					$$ = g_node_new((gpointer)BLOC);
					g_node_append($$, $1); //La structure conditionnelle
					g_node_append($$, $2); //La suite des instructions
				}
				| structure_iterative bloc_instruction {
					$$ = g_node_new((gpointer)BLOC);
					g_node_append($$, $1); //La structure itérative
					g_node_append($$, $2); //La suite des instructions
				}
				| %empty {
					$$ = g_node_new((gpointer)VIDE);
				}
				;

instruction	: TOK_ID TOK_PARL arguments TOK_PARR {
				$$ = g_node_new((gpointer)INSTRUCTION);
				g_node_append_data($$, $1); //Identifiant de l'instruction
				g_node_append($$, $3); //Suite des declaration

			}
		   	| TOK_ID TOK_EQUAL expression {
				$$ = g_node_new((gpointer)AFFECTATION);
				g_node_append_data($$, $1); //Identifiant de la variable cible de l'affectation
				g_node_append($$, $3); //Expression de l'affectation
			}
		   	;

structure_conditionnelle: TOK_IF expression TOK_THEN bloc_instruction TOK_EIF {
							$$ = g_node_new((gpointer)IF);
							g_node_append($$, $2);
							g_node_append($$, $4);
						}
						| TOK_IF expression TOK_THEN bloc_instruction TOK_ELSE bloc_instruction TOK_EIF {
							$$ = g_node_new((gpointer)IF_ELSE);
							g_node_append($$, $2);
							g_node_append($$, $4);
							g_node_append($$, $6);
						}
						;

structure_iterative	: TOK_FOR TOK_ID TOK_FROM operande TOK_TO operande TOK_DO bloc_instruction TOK_EFOR {
						$$ = g_node_new((gpointer)FOR);
						g_node_append_data($$, $2);
						g_node_append($$, $4);
						g_node_append($$, $6);
						g_node_append($$, $8);
					}
				   	| TOK_FOR TOK_ID TOK_FROM operande TOK_TO operande TOK_BY_STEP operande TOK_DO bloc_instruction TOK_EFOR {
						$$ = g_node_new((gpointer)FOR_BY_STEP);
						g_node_append_data($$, $2);
						g_node_append($$, $4);
						g_node_append($$, $6);
						g_node_append($$, $8);
						g_node_append($$, $10);
					}
				   	| TOK_WHILE expression TOK_DO bloc_instruction TOK_EWHILE {
						$$ = g_node_new((gpointer)WHILE);
						g_node_append($$, $2);
						g_node_append($$, $4);
					}
				   	;

arguments	: argument TOK_COMMA arguments {
				$$ = g_node_new((gpointer)ARGUMENTS);
				g_node_append($$, $1);
				g_node_append($$, $3);
			}
		 	| argument {
				$$ = $1;
			}
		 	;

argument: expression {
			$$ = g_node_new((gpointer)ARGUMENT);
			g_node_append($$, $1);
		}
		| TOK_STRING {
			$$ = g_node_new((gpointer)ARG_STRING);
			g_node_append_data($$, $1);
		}
		;

expression	: operande {
				$$ = g_node_new((gpointer)OPERANDE);
				g_node_append($$, $1);
			}
		  	| operande TOK_OP expression {
				$$ = g_node_new((gpointer)EXPRESSION);
				g_node_append($$, $1);
				g_node_append_data($$, $2);
				g_node_append($$, $3);
			}
		  	| TOK_PARL expression TOK_PARR {
				$$ = g_node_new((gpointer)EXPRESSION_PAR);
				g_node_append($$, $2);
			}
		  	;

operande: TOK_ID {
			$$ = g_node_new((gpointer)ID);
			g_node_append_data($$, $1);
		}
		| TOK_INT {
			$$ = g_node_new((gpointer)ENTIER);
			g_node_append_data($$, $1);
		}
		| TOK_FLOAT {
			$$ = g_node_new((gpointer)REEL);
			g_node_append_data($$, $1);
		}
		| TOK_CHAR {
			$$ = g_node_new((gpointer)CARACTERE);
			g_node_append_data($$, $1);
		}
		| TOK_BOOL {
			$$ = g_node_new((gpointer)BOOLEEN);
			g_node_append_data($$, $1);
		}
		;

%%

int main (int argc, char* argv[]) {
	
	init();

	begin_code();
    yyparse();
	end_code();

	cleanup();

	return EXIT_SUCCESS;
}

void init() {
	if( (var_hash_table = g_hash_table_new(g_str_hash, g_str_equal)) == NULL ) {
		perror("g_hash_table_new");
	}
	else {
		//printf("Table de hachage crée avec succes\n");
	}
}

void cleanup() {
	g_hash_table_destroy(var_hash_table);
}

int yyerror (const char *msg) {
    fprintf(stderr, "ERREUR(%d) : %s\n", nb_line, msg);
}