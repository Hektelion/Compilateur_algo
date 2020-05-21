%{

#include <string.h>

#include <constant.h>

void debug_token(int v_token);

char chaine[128];
 
%}

%option noyywrap

%x STRING

commentaire         	((\/\/|#).*)

%%

{commentaire}           { printf("commentaire ignorée : %s\n", yytext); }

"\""                    { BEGIN(STRING); }
<STRING>"\""            { BEGIN(INITIAL); }
<STRING>.				{  }

"\n"            		{  }
" "|"\t"				{  }
.						{ printf("Non reconnu : %s\n", yytext); }
<<EOF>>					{ yyterminate(); }

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