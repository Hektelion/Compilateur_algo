%{

#include <string.h>

#include <constant.h>

void debug_token(int v_token);

%}

%option noyywrap

commentaire         ((\/\/|#).*)

%%

{commentaire}                   { printf("commentaire ignorée : %s\n", yytext); }

"\n"            				{ }
" "|"\t"						{  }
.								{ printf("Non reconnu : %s\n", yytext); }
<<EOF>>							{ yyterminate(); }

%%

int main() {
    int token;

    printf("#");

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