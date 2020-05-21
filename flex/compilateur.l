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

commentaire         	((\/\/|#).*)
type					("entier"|"reel"|"caractere"|"booleen"|"chaine de caractere")

%%

{commentaire}           	{ /* printf("commentaire ignorée : %s\n", yytext); */ }

"\""                    	{  BEGIN(STRING); }
<STRING>"\""            	{  BEGIN(INITIAL); }
<STRING>.					{  }

"Algorithme"				{ BEGIN(DECL_ALGO); }
<DECL_ALGO>[ ]				{  }
<DECL_ALGO>.*				{ printf("Algorithme : %s\n", yytext); }
<DECL_ALGO>\n				{ BEGIN(INITIAL); }

"Role"						{ BEGIN(DEF_ROLE); }
<DEF_ROLE>":"				{  }
<DEF_ROLE>[ ]				{  }
<DEF_ROLE>.*				{ printf("Role : %s\n", yytext); }
<DEF_ROLE>\n				{ BEGIN(INITIAL); }

"Declaration"				{ printf("Entrer dans la zone de déclaration\n"); BEGIN(DECLARE_ZONE); }
<DECLARE_ZONE>"Debut"		{ printf("Sortie de la zone de déclaration\n"); BEGIN(INITIAL); }
<DECLARE_ZONE>{commentaire}	{ /* printf("commentaire dans la zone de declaration ignorée : %s\n", yytext); */ }
<DECLARE_ZONE>[ ]			{  }
<DECLARE_ZONE>\n			{ printf("nouvelle variable : "); }
<DECLARE_ZONE>":"			{ printf(" -> "); }
<DECLARE_ZONE>","			{ printf(" ; "); }
<DECLARE_ZONE>{type}		{ printf("%s\n", yytext); }
<DECLARE_ZONE>[a-z|A-Z|_]*	{printf("%s", yytext); }

"\n"            			{  }
" "|"\t"					{  }
.							{ /* printf("Non reconnu : %s\n", yytext); */ }
<<EOF>>						{ yyterminate(); }

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