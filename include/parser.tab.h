/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOK_ALGO = 258,
    TOK_ALGO_NAME = 259,
    TOK_ROLE = 260,
    TOK_ROLE_DESC = 261,
    TOK_DECLARE = 262,
    TOK_BEGIN = 263,
    TOK_END = 264,
    TOK_TYPE = 265,
    TOK_IF = 266,
    TOK_ELSE = 267,
    TOK_THEN = 268,
    TOK_EIF = 269,
    TOK_FOR = 270,
    TOK_FROM = 271,
    TOK_TO = 272,
    TOK_BY_STEP = 273,
    TOK_DO = 274,
    TOK_EFOR = 275,
    TOK_WHILE = 276,
    TOK_EWHILE = 277,
    TOK_INT = 278,
    TOK_FLOAT = 279,
    TOK_CHAR = 280,
    TOK_BOOL = 281,
    TOK_STRING = 282,
    TOK_OP = 283,
    TOK_EQUAL = 284,
    TOK_PARL = 285,
    TOK_PARR = 286,
    TOK_COLON = 287,
    TOK_COMMA = 288,
    TOK_ID = 289
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 30 "./bison/parser.y"

    char *chaine;
	int nombre;

#line 97 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
