#ifndef GENERATOR_H
#define GENERATOR_H

#include <stdio.h>

static int indent=1;

void print_indent() {
    for(int i=0 ; i<indent ; i++)
        fprintf(stdout, "\t");
}

void begin_code() {
    fprintf(stdout, "#include <stdio.h>\n"
                    "#include <stdlib.h>\n"
                    "#include <string.h>\n\n"
                    "int main() {\n\n");
}

void gen_code(GNode *ast) {
    if(ast) {
        switch ((long)ast->data) {
            case VIDE:
                /* code */
                break;

            case ALGORITHME:
                gen_code(g_node_nth_child(ast,0));
                gen_code(g_node_nth_child(ast,1));
                break;

            case DECLARATION:
                print_indent();
                fprintf(stdout, "%s ", (char *)g_node_nth_child(ast,1)->data);
                fprintf(stdout, "%s;\n", (char *)g_node_nth_child(ast,0)->data);
                gen_code(g_node_nth_child(ast,2));
                break;

            case BLOC:
                gen_code(g_node_nth_child(ast,0));
                gen_code(g_node_nth_child(ast,1));
                break;

            case INSTRUCTION:
                print_indent();
                fprintf(stdout, "%s(", (char *)g_node_nth_child(ast,0)->data);
                gen_code(g_node_nth_child(ast,1));
                fprintf(stdout, ");\n");
                break;

            case AFFECTATION:
                print_indent();
                fprintf(stdout, "%s = ", (char *)g_node_nth_child(ast,0)->data);
                gen_code(g_node_nth_child(ast,1));
                fprintf(stdout, ";\n");
                break;

            case IF:
                print_indent();
                fprintf(stdout, "if( ");
                gen_code(g_node_nth_child(ast,0));
                fprintf(stdout, " ) {\n");
                indent++;
                gen_code(g_node_nth_child(ast,1));
                indent--;
                print_indent();
                fprintf(stdout, "}\n");
                break;

            case IF_ELSE:
                print_indent();
                fprintf(stdout, "if( ");
                gen_code(g_node_nth_child(ast,0));
                fprintf(stdout, " ) {\n");
                indent++;
                gen_code(g_node_nth_child(ast,1));
                indent--;
                print_indent();
                fprintf(stdout, "}\n");

                print_indent();
                fprintf(stdout, "else {");
                indent++;
                gen_code(g_node_nth_child(ast,2));
                indent--;
                print_indent();
                fprintf(stdout, "}\n");
                break;

            case FOR:
                print_indent();
                fprintf(stdout, "for( %s=", (char *)g_node_nth_child(ast,0)->data);
                gen_code(g_node_nth_child(ast,1));
                fprintf(stdout, " ; %s<=", (char *)g_node_nth_child(ast,0)->data);
                gen_code(g_node_nth_child(ast,2));
                fprintf(stdout, " ; %s++ ) {\n", (char *)g_node_nth_child(ast,0)->data);
                indent++;
                gen_code(g_node_nth_child(ast,3));
                indent--;
                print_indent();
                fprintf(stdout, "}\n");
                break;

            case FOR_BY_STEP:
                print_indent();
                fprintf(stdout, "for( %s=", (char *)g_node_nth_child(ast,0)->data);
                gen_code(g_node_nth_child(ast,1));
                fprintf(stdout, " ; %s<=", (char *)g_node_nth_child(ast,0)->data);
                gen_code(g_node_nth_child(ast,2));
                fprintf(stdout, " ; %s+=", (char *)g_node_nth_child(ast,0)->data);
                gen_code(g_node_nth_child(ast,3));
                fprintf(stdout, " ) {\n");
                indent++;
                gen_code(g_node_nth_child(ast,4));
                indent--;
                print_indent();
                fprintf(stdout, "}\n");
                break;

            case WHILE:
                print_indent();
                fprintf(stdout, "while( ");
                gen_code(g_node_nth_child(ast,0));
                fprintf(stdout, " ) {\n");
                indent++;
                gen_code(g_node_nth_child(ast,1));
                indent--;
                print_indent();
                fprintf(stdout, "}\n");
                break;

            case ARGUMENTS:
                gen_code(g_node_nth_child(ast,0));
                fprintf(stdout, ", ");
                gen_code(g_node_nth_child(ast,1));
                break;

            case ARGUMENT:
                gen_code(g_node_nth_child(ast,0));
                break;

            case ARG_STRING:
                fprintf(stdout, "%s", (char *)g_node_nth_child(ast,0)->data);
                break;

            case OPERANDE:
                gen_code(g_node_nth_child(ast,0));
                break;

            case EXPRESSION:
                gen_code(g_node_nth_child(ast,0));
                fprintf(stdout, " %s ", (char *)g_node_nth_child(ast,1)->data);
                gen_code(g_node_nth_child(ast,2));
                break;

            case EXPRESSION_PAR:
                fprintf(stdout, "( ");
                gen_code(g_node_nth_child(ast,0));
                fprintf(stdout, " )");
                break;

            case ID:
                fprintf(stdout, "%s", (char *)g_node_nth_child(ast,0)->data);
                break;

            case ENTIER:
                fprintf(stdout, "%s", (char *)g_node_nth_child(ast,0)->data);
                break;

            case REEL:
                fprintf(stdout, "%s", (char *)g_node_nth_child(ast,0)->data);
                break;

            case CARACTERE:
                fprintf(stdout, "%s", (char *)g_node_nth_child(ast,0)->data);
                break;

            case BOOLEEN:
                fprintf(stdout, "%s", (char *)g_node_nth_child(ast,0)->data);
                break;
            
            default:
                fprintf(stderr, "ERREUR\n");
                break;
        }
    }
}

void end_code() {
    fprintf(stdout, "\nreturn 0;\n\n"
                    "}\n");
}

#endif