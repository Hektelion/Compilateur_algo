%{

#include <string.h>

#include <include.h>

//#include <constant.h>

void indent(int v_token);
void debug_token(int v_token);

char chaine[1024];
int current_indent=0;

int nb_line=1;
 
%}

%option noyywrap

%x STRING
%x DECL_ALGO
%x DEF_ROLE
%x DECLARE_ZONE
%x FOR_DEF
%x WHILE_DEF
%x IF_DEF_ZONE

commentaire         	((\/\/|#).*)
identifiant				-[a-z|A-Z][a-z|A-Z|0-9|_]*|[a-z|A-Z][a-z|A-Z|0-9|_]*
nombre					-[0-9]+|[0-9]+
type					("entier"|"reel"|"caractere"|"booleen"|"chaine de caractere")
operateur_booleen		("=="|"!="|">"|"<"|">="|"<=")
operateur_arithmetique	("+"|"-"|"*"|"/"|"%")

%%

<DECLARE_ZONE,INITIAL>{commentaire}	{							/* VERIFIER LES TOKENS RENVOYE */
	/* printf("commentaire ignorée : %s\n", yytext); */
}

<INITIAL>"\"" { /* concatené les éléments */
	BEGIN(STRING);
	memset(chaine, 0, strlen(chaine));
	strcat(chaine, "\"");
}

<STRING>"\"" {
	BEGIN(INITIAL);
	strcat(chaine, "\"");
	yytext = chaine;
	yylval.chaine = strdup(yytext);
	return(TOK_STRING);
}

<STRING>.	{
	strcat(chaine, yytext);
}

<INITIAL>"Algorithme" {
	yylval.chaine = strdup(yytext);
	BEGIN(DECL_ALGO);
	return(TOK_ALGO);
}

<DECL_ALGO>.*	{
	yylval.chaine = strdup(yytext);
	return(TOK_ALGO_NAME);
}

<INITIAL>"Role"	{
	yylval.chaine = strdup(yytext);
	BEGIN(DEF_ROLE);
	return(TOK_ROLE);
}

<DEF_ROLE>(" "|"\t") {
	
}

<DEF_ROLE>":"	{
	yylval.chaine = strdup(yytext);
	return(TOK_COMMA);
}

<DEF_ROLE>.*	{
	yylval.chaine = strdup(yytext);
	return(TOK_ROLE_DESC);
}

<DECL_ALGO,DEF_ROLE>\n	{
	nb_line++;
	BEGIN(INITIAL);
}

<INITIAL>"Declaration"	{
	yylval.chaine = strdup(yytext);
	BEGIN(DECLARE_ZONE);
	return(TOK_DECLARE);
}

<DECLARE_ZONE>"Debut"	{
	yylval.chaine = strdup(yytext);
	BEGIN(INITIAL);
	return(TOK_BEGIN);
}

<DECLARE_ZONE>":"	{
	yylval.chaine = strdup(yytext);
	return(TOK_COMMA);
}

<DECLARE_ZONE>","	{
	yylval.chaine = strdup(yytext);
	return(TOK_COLON);
}

<DECLARE_ZONE>{type}	{
	yylval.chaine = strdup(yytext);
	return(TOK_TYPE);
}

<INITIAL>"Fin" {
	yylval.chaine = strdup(yytext);
	return(TOK_END);
}

<INITIAL>"pour" {
	yylval.chaine = strdup(yytext);
	BEGIN(FOR_DEF);
	return(TOK_FOR);
}

<INITIAL>"tant"[ ]*"que"	{
	yylval.chaine = strdup(yytext);
	BEGIN(WHILE_DEF);
	return(TOK_WHILE); 
}

<INITIAL>"sinon" {
	yylval.chaine = strdup(yytext);
	return(TOK_ELSE);
}

<INITIAL>"si" {
	yylval.chaine = strdup(yytext);
	BEGIN(IF_DEF_ZONE);
	return(TOK_IF);
}

<INITIAL>"fpour" {
	yylval.chaine = strdup(yytext);
	return(TOK_EFOR);
}

<INITIAL>"ftant"	{
	yylval.chaine = strdup(yytext);
	return(TOK_EWHILE);
}

<INITIAL>"fsi"	{
	yylval.chaine = strdup(yytext);
	return(TOK_EIF);
}

<INITIAL>"="	{
	yylval.chaine = strdup(yytext);
	return(TOK_EQUAL);
}

<INITIAL,IF_DEF_ZONE>"(" {
	yylval.chaine = strdup(yytext);
	return(TOK_PARL);
}

<INITIAL>"," {
	yylval.chaine = strdup(yytext);
	return(TOK_COMMA);
}

<INITIAL,IF_DEF_ZONE>")" {
	yylval.chaine = strdup(yytext);
	return(TOK_PARR);
}

<FOR_DEF>"par"[ ]*"pas"[ ]*"de" {
	yylval.chaine = strdup(yytext);
	return(TOK_BY_STEP);
}

<FOR_DEF>"de" {
	yylval.chaine = strdup(yytext);
	return(TOK_FROM);
}

<FOR_DEF>"a" {
	yylval.chaine = strdup(yytext);
	return(TOK_TO);
}

<IF_DEF_ZONE>"alors" {
	yylval.chaine = strdup(yytext);
	BEGIN(INITIAL);
	return(TOK_THEN);
}

<FOR_DEF,WHILE_DEF>"faire" {
	yylval.chaine = strdup(yytext);
	BEGIN(INITIAL);
	return(TOK_DO);
}

<INITIAL,WHILE_DEF,FOR_DEF,IF_DEF_ZONE>{operateur_booleen}	{
	yylval.chaine = strdup(yytext);
	return(TOK_OP);
}

<INITIAL,IF_DEF_ZONE,FOR_DEF,WHILE_DEF>{operateur_arithmetique}	{
	yylval.chaine = strdup(yytext);
	return(TOK_OP);
}


<INITIAL,DECLARE_ZONE,IF_DEF_ZONE,FOR_DEF,WHILE_DEF>{identifiant} {
	yylval.chaine = strdup(yytext);
	return(TOK_ID);
}

<IF_DEF_ZONE,FOR_DEF,WHILE_DEF>{nombre} {
	yylval.chaine =  strdup(yytext);
	return(TOK_INT);
}

<INITIAL,DECL_ALGO,DECLARE_ZONE,IF_DEF_ZONE,FOR_DEF,WHILE_DEF>(" "|"\t") {

}

<INITIAL,DECLARE_ZONE,WHILE_DEF,FOR_DEF,IF_DEF_ZONE>\n {
	nb_line++;
}

<INITIAL,DECLARE_ZONE>. {
	printf("Non reconnu : %s\n", yytext);
}

<INITIAL><<EOF>>	{
	yyterminate();
}

%%

/*
int main() {
    int token;

    do
	{
		token = yylex();
		indent(token);
		debug_token(token);
	}
	while(token != 0);

	printf("\n");

    return 0;
}
*/

void indent(int v_token) {
	switch(v_token) {
		case TOK_DECLARE:
		case TOK_BEGIN:
		case TOK_END:
		case TOK_ELSE:
		case TOK_THEN:
		case TOK_DO:
			current_indent++;
			break;

		case TOK_EIF:
		case TOK_EFOR:
		case TOK_EWHILE:
			current_indent--;
			break;
	}
	for(int i=0 ; i<current_indent ; i++) printf("\t");
}

void debug_token(int v_token) {
	switch(v_token) {
		case TOK_ALGO: printf("TOK_ALGO"); break;
		case TOK_ALGO_NAME: printf("TOK_ALGO_NAME"); break;
		case TOK_ROLE: printf("TOK_ROLE"); break;
		case TOK_ROLE_DESC: printf("TOK_ROLE_DESC"); break;
		case TOK_DECLARE: printf("TOK_DECLARE"); break;
		case TOK_BEGIN: printf("TOK_BEGIN"); break;
		case TOK_END: printf("TOK_END");  break;

		case TOK_TYPE: printf("TOK_TYPE");  break;

		case TOK_IF: printf("TOK_IF");  break;
		case TOK_ELSE: printf("TOK_ELSE");  break;
		case TOK_THEN: printf("TOK_THEN");  break;
		case TOK_EIF: printf("TOK_EIF");  break;

		case TOK_FOR: printf("TOK_FOR");  break;
		case TOK_FROM: printf("TOK_FROM");  break;
		case TOK_TO: printf("TOK_TO");  break;
		case TOK_BY_STEP: printf("TOK_BY_STEP");  break;
		case TOK_DO: printf("TOK_DO");  break;
		case TOK_EFOR: printf("TOK_EFOR");  break;

		case TOK_WHILE: printf("TOK_WHILE");  break;
		case TOK_EWHILE: printf("TOK_EWHILE");  break;

		case TOK_INT: printf("TOK_INT");  break;
		case TOK_FLOAT: printf("TOK_FLOAT");  break;
		case TOK_CHAR: printf("TOK_CHAR");  break;
		case TOK_BOOL: printf("TOK_BOOL");  break;
		case TOK_STRING: printf("TOK_STRING");  break;

		case TOK_OP: printf("TOK_OP");  break;
		case TOK_EQUAL: printf("TOK_EQUAL");  break;

		case TOK_PARL: printf("TOK_PARL");  break;
		case TOK_PARR: printf("TOK_PARR");  break;
		case TOK_COLON: printf("TOK_COLON");  break;
		case TOK_COMMA: printf("TOK_COMMA");  break;

		case TOK_ID: printf("TOK_ID");  break;

		default: printf("ERREUR <-----------------\n"); break;
	}
	printf(" : %s\n", yytext);
}