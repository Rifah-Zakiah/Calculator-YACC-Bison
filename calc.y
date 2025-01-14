%{
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
int yylex();
void yyerror(const char *s);
float factorial(int n)
{
  int c;
  float result = 1;
 
  for (c = 1; c <= n; c++)
    result = result * c;
 
  return result;
}
%}



%union{
	double dval;
}

%token <dval> NUMBER
%type<dval>expr
%token SIN COS TAN LOG SQRT FACTORIAL
%token CMD_EXT

%left '+' '-'
%left '*' '/'
%right '^' '!'
%right UMINUS /* Unary minus */

%%

calculate:
	calculate '\n'
	| calculate expr '\n' {printf("Result: %f\n", $2);}
	| calculate CMD_EXT { printf(">> Bye!\n"); exit(0); }
	| /* empty rule */

expr: 
	expr '+' expr	{$$ = $1 + $3;}
	| expr '-' expr	{$$ = $1 - $3;}
	| expr '*' expr	{$$ = $1 * $3;}
	| expr '/' expr	{
						if($3 == 0){
							yyerror("Division by 0");
							$$ = 0;
						}else{
							$$ = $1 / $3;
						}
			    	}
	| '-' expr %prec UMINUS {$$ =-$2;}
	| '(' expr ')' 		{$$ =$2;}
	| SIN '(' expr ')' 	{$$ =sin($3);}
	| COS '(' expr ')'	{$$ =cos($3);}
	| TAN '(' expr ')'	{$$ =tan($3);}
	| LOG '(' expr ')'	{
							if($3 <= 0){
								yyerror("Logarithm of non-positive number");
								$$ = 0;
							}else{
								$$ = log($3);
							}
						}
	| SQRT '(' expr ')'	{
							if($3 < 0){
								yyerror("Square root of negative numbr");
								$$ = 0;
							} else {
								$$ = sqrt($3);
							}
				  		}
	| expr '^' expr		{ $$ = pow($1, $3); }
	| FACTORIAL '(' expr ')' { $$ = factorial((int)$3);}
	| expr '!' { $$ = factorial((int)$1); }
	| NUMBER		{ $$ = $1; }
%%

int main() {
	printf("Enter expressions to calculate: \n");
	yyparse();
	return 0;
}

void yyerror(const char *s) {
	fprintf(stderr, "Error: %s\n", s);
}