#ifndef CONSTANT_H
#define CONSTANT_H

/* token mot-clés génaral du langage  */

#define TOK_ALGO            1
#define TOK_ALGO_NAME       2
#define TOK_ROLE            3
#define TOK_ROLE_DESC       4
#define TOK_DECLARE         5
#define TOK_BEGIN           6
#define TOK_END             7

/* token mot-clés type */

#define TOK_TYPE            8

/* token mot-clés si */

#define TOK_IF              9
#define TOK_ELSE            10
#define TOK_THEN            11
#define TOK_EIF             12

/* token mot-clés pour */

#define TOK_FOR             13
#define TOK_FROM			14
#define TOK_TO				15
#define TOK_BY_STEP			16
#define TOK_DO				17
#define TOK_EFOR			18

/* token mot-clés tant que */

#define TOK_WHILE			19
#define TOK_EWHILE			20

/* token types valeur */

#define TOK_INT				21
#define TOK_FLOAT			22
#define TOK_CHAR			23
#define TOK_BOOL			24
#define TOK_STRING			25

/* token opérateures */

#define TOK_OP				26
#define TOK_EQUAL			27

/* token symboles */

#define TOK_PARL			28
#define TOK_PARR			29
#define TOK_COLON			30
#define TOK_COMMA			31
#define TOK_QUOTE			32

/* token autres */

#define TOK_ID				33

#endif