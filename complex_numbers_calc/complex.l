%{

#include "y.tab.h" 

%}

number       "-"?([1-9][0-9]*|"0")([.][0-9]*)?	

i	"i"

%%



{number}	{
	    printf("Token: NUMBER;  Lexeme: %s\n", yytext);
            yylval.num = atof(yytext);
            return  NUMBER;
			}

{i}  {
            printf("Token: I;  Lexeme: %s\n", yytext);
            yylval.str = strdup(yytext);
            return  I;
}

[+-/*(),]   {
            printf("Token and Lexeme: %s\n", yytext);

            return  *yytext;

        }

[\n|\r\n]      {
            printf("Token and Lexeme: <newline>\n");

            return  *yytext;

        }


[ \t]   {    }     /*  skip whitespace  */


.       {
           printf("Invalid character.\n");
           //yyerror("invalid character");
        }
     /*  will match any single character that does not match
         any of the above patterns
     */


%%

/*** C Code section ***/

void yyerror(char *s) {
      fprintf(stderr, "line %d: yytext = %s.  Error msg: %s.\n", yylineno, yytext, s);
}


int yywrap(void) {
   return 1;
}