%{
#include "calc.tab.h"
%}

%%
[0-9]+(\.[0-9]+)? { yylval.dval = atof(yytext);
		   // printf("Token: NUMBER, VALUE: %f\n", yylval.dval);
		    return NUMBER; }
"sin"		  { return SIN; }
"cos"		  { return COS; }
"tan"		  { return TAN; }
"log"		  { return LOG; }
"sqrt"		  { return SQRT; }
"factorial"	  { return FACTORIAL;}
[+\-*/^!()]	  { return yytext[0]; }
[ \t]		  { /*Ignore white spaces */ }
\n		  { return '\n'; }
"quit"|"exit"	  { return CMD_EXT; }
.		  { printf("Unknown character: %s\n", yytext); }
%%

int yywrap() {
	return 1;
}
