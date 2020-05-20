%{

#include <string.h>

#include <constant.h>

void debug_token(int v_token);

%}

%option noyywrap


%%

"\n"            				{  }
" "|"\t"						{  }
.								{  }
<<EOF>>							{ yyterminate(); }

%%

void debug_token(int v_token) {

}