%{

#include <string.h>

#include <constant.h>

void debug_token(int v_token);

char *chaine;
 
%}

%option noyywrap

%x STRING
%x DECL_ALGO
%x DEF_ROLE
%x DECLARE_ZONE
%x PROGRAM_ZONE
%x INSTRUCTION_ZONE
%x FOR_DEF
%x WHILE_DEF
%x IF_DEF

commentaire         	((\/\/|#).*)
identifiant				[a-z|A-Z][a-z|A-Z|_]*
nombre					[0-9]+
type					("entier"|"reel"|"caractere"|"booleen"|"chaine de caractere")

%%

{commentaire}           		{ /* printf("commentaire ignorée : %s\n", yytext); */ }

<PROGRAM_ZONE,WHILE_DEF,IF_DEF>"=="				{ printf("opérateur booleen : %s\n", yytext); }
<PROGRAM_ZONE,WHILE_DEF,IF_DEF>"!="				{ printf("opérateur booleen : %s\n", yytext); }
<PROGRAM_ZONE,WHILE_DEF,IF_DEF>"<="				{ printf("opérateur booleen : %s\n", yytext); }
<PROGRAM_ZONE,WHILE_DEF,IF_DEF>">="				{ printf("opérateur booleen : %s\n", yytext); }
<PROGRAM_ZONE,WHILE_DEF,IF_DEF>">"				{ printf("opérateur booleen : %s\n", yytext); }
<PROGRAM_ZONE,WHILE_DEF,IF_DEF>"<"				{ printf("opérateur booleen : %s\n", yytext); }
<PROGRAM_ZONE,WHILE_DEF,IF_DEF>"="				{ printf("opérateur arithmétique : %s\n", yytext); }
<PROGRAM_ZONE,WHILE_DEF,IF_DEF>"+"				{ printf("opérateur arithmétique : %s\n", yytext); }
<PROGRAM_ZONE,WHILE_DEF,IF_DEF>"-"				{ printf("opérateur arithmétique : %s\n", yytext); }
<PROGRAM_ZONE,WHILE_DEF,IF_DEF>"*"				{ printf("opérateur arithmétique : %s\n", yytext); }
<PROGRAM_ZONE,WHILE_DEF,IF_DEF>"/"				{ printf("opérateur arithmétique : %s\n", yytext); }
<PROGRAM_ZONE,WHILE_DEF,IF_DEF>"%"				{ printf("opérateur arithmétique : %s\n", yytext); }

<INITIAL,INSTRUCTION_ZONE,PROGRAM_ZONE>"\""      { printf("chaine de caracteres : \""); BEGIN(STRING); }
<STRING>"\""            		{ printf("\"\n"); BEGIN(INSTRUCTION_ZONE); }
<STRING>.						{ printf("%s", yytext); }

"Algorithme"					{ BEGIN(DECL_ALGO); }
<DECL_ALGO>[ ]					{  }
<DECL_ALGO>.*					{ printf("Algorithme : %s\n", yytext); }
<DECL_ALGO>\n					{ BEGIN(INITIAL); }

"Role"							{ BEGIN(DEF_ROLE); }
<DEF_ROLE>":"					{  }
<DEF_ROLE>.*					{ printf("Role : %s\n", yytext); }
<DEF_ROLE>\n					{ BEGIN(INITIAL); }

"Declaration"					{ printf("Entrer dans la zone de déclaration\n"); BEGIN(DECLARE_ZONE); }
<DECLARE_ZONE>"Debut"			{ printf("Sortie de la zone de déclaration\n"); printf("Entrer dans le programme\n"); BEGIN(PROGRAM_ZONE); }
<DECLARE_ZONE>{commentaire}		{ /* printf("commentaire dans la zone de declaration ignorée : %s\n", yytext); */ }
<DECLARE_ZONE>":"				{ printf(" : "); }
<DECLARE_ZONE>","				{ printf(" , "); }
<DECLARE_ZONE>{type}			{ printf("%s\n", yytext); }
<DECLARE_ZONE>{identifiant}		{printf("%s", yytext); }
<DECLARE_ZONE>[ ]				{  }
<DECLARE_ZONE>.					{ printf("Non reconnu dans la zone de declaration : %s\n", yytext); }
<DECLARE_ZONE>\n				{  }

<PROGRAM_ZONE>"Fin"				{ printf("Sortie du programme\n"); BEGIN(INITIAL); }
<PROGRAM_ZONE>"pour"			{ printf("debut d'une structure : %s\n", yytext); BEGIN(FOR_DEF); }
<PROGRAM_ZONE>"tant"[ ]*"que"	{ printf("debut d'une structure : %s\n", yytext); BEGIN(WHILE_DEF); }
<PROGRAM_ZONE>"si"				{ printf("debut d'une structure : %s\n", yytext); }
<PROGRAM_ZONE>"fpour"			{ printf("fin de pour\n"); }
<PROGRAM_ZONE>"ftant"			{ printf("fin de tant que\n"); }
<PROGRAM_ZONE>"fsi"				{ printf("fin de si\n"); }
<PROGRAM_ZONE>"("				{ printf("Debut arguments : %s\n", yytext); BEGIN(INSTRUCTION_ZONE); }
<PROGRAM_ZONE>{identifiant}		{ printf("identifiant : %s\n", yytext); }
<PROGRAM_ZONE>{commentaire}		{ printf("commentaire dans le programme ignorée : %s\n", yytext); }
<PROGRAM_ZONE>[ ]				{  }
<PROGRAM_ZONE>.					{ printf("[ATTENTION] Non reconnu dans le programme : %s\n", yytext); }
<PROGRAM_ZONE>\n				{  }

<INSTRUCTION_ZONE>{identifiant}	{ printf("identifiant en parametre : %s\n", yytext); } /*ajouter nombre*/
<INSTRUCTION_ZONE>","			{ printf(" , \n"); }
<INSTRUCTION_ZONE>")"			{ printf("Fin arguments : %s\n", yytext); BEGIN(PROGRAM_ZONE); }
<INSTRUCTION_ZONE>[ ]			{  }

<FOR_DEF>("allant"[ ]*"de")		{ printf("mot clé : %s\n", yytext); }
<FOR_DEF>"a"					{ printf("mot clé : %s\n", yytext); }
<FOR_DEF>"faire"				{ printf("fin de structure pour : %s\n", yytext); BEGIN(PROGRAM_ZONE); }
<FOR_DEF>{identifiant}			{ printf("identifiant : %s\n", yytext); }
<FOR_DEF>{nombre}				{ printf("nombre : %s\n", yytext); }
<FOR_DEF>[ ]					{  }

<WHILE_DEF>"faire"				{ printf("fin de structure tant que : %s\n", yytext); BEGIN(PROGRAM_ZONE); }
<WHILE_DEF>{identifiant}		{ printf("identifiant : %s\n", yytext); }
<WHILE_DEF>{nombre}				{ printf("nombre : %s\n", yytext); }
<WHILE_DEF>[ ]					{  }

"\n"            				{  }
" "|"\t"						{  }
.								{ /* printf("Non reconnu : %s\n", yytext); */ }
<<EOF>>							{ yyterminate(); }

%%

int main() {
    int token;

    do
	{
		token = yylex();
		debug_token(token);
	}
	while(token != 0);

    return 0;
}

void debug_token(int v_token) {

}