#ifndef INCLUDE_H
#define INCLUDE_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <glib.h>
#include <parser.tab.h>
int yylex (void);
int yyerror (const char *msg);

#endif  