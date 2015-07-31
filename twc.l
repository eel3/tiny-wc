%{
#include <stdio.h>
#include <stdlib.h>

static size_t nc, nw, nl;
%}

WORD    [^ \t\n]+
EOL     \n
%%
{WORD}              { nw++; nc += yyleng; }
{WORD}-{EOL}{WORD}  { nl++; nw++; nc += yyleng; }
{EOL}               { nl++; nc++; }
.                   { nc++; }
%%

int yywrap(void) { return 1; }

int main(void)
{
	nc = nw = nl = 0;
	yylex();
	(void) printf("%lu\t%lu\t%lu\n",
	              (unsigned long) nl,
	              (unsigned long) nw,
	              (unsigned long) nc);

	return EXIT_SUCCESS;
}
