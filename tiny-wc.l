%{
/* ********************************************************************** */
/**
 * @brief   Tiny wc(1) (Test project for Lex).
 * @author  eel3
 * @date    2015/05/12
 *
 * @par Compilers
 *   - GCC 4.6.3 (Ubuntu 12.04.4 LTS 32bit)
 *   - TDM-GCC 4.8.1 (Windows 7 64bit SP1)
 *   - Visual Studio 2005 Professional SP1 (Windows 7 64bit SP1)
 *   - Visual Studio 2013 Professional with Update 4 (Windows 7 64bit SP1)
 */
/* ********************************************************************** */


#if defined(_WIN32) || defined(_WIN64)
#	if !defined(__MINGW32__) && !defined(__MINGW64__)
#		ifndef _CRT_SECURE_NO_WARNINGS
#			define _CRT_SECURE_NO_WARNINGS
#		endif /* ndef _CRT_SECURE_NO_WARNINGS */
#	endif /* !defined(__MINGW32__) && !defined(__MINGW64__) */
#	define PATH_SEP '\\'
#else /* defined(_WIN32) || defined(_WIN64) */
#	define PATH_SEP '/'
#endif /* defined(_WIN32) || defined(_WIN64) */

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>


/* ---------------------------------------------------------------------- */
/* Variable */
/* ---------------------------------------------------------------------- */

static size_t nc;   /**< Num of chars. */
static size_t nw;   /**< Num of words. */
static size_t nl;   /**< Num of lines. */

%}

WORD    [^ \t\n]+
EOL     \n

%%

{WORD}              { nw++; nc += yyleng; }
{WORD}-{EOL}{WORD}  { nl++; nw++; nc += yyleng; }
{EOL}               { nl++; nc++; }
.                   { nc++; }

%%

/* ---------------------------------------------------------------------- */
/* Function-like macro */
/* ---------------------------------------------------------------------- */

/* ====================================================================== */
/**
 * @brief  Return true if string s1 equal to s2.
 *
 * @param[in] s1  string 1.
 * @param[in] s2  string 2.
 *
 * @retval !=0  Equal.
 * @retval   0  Not equal.
 */
/* ====================================================================== */
#define  STREQ(s1, s2)  (((s1)[0] == (s2)[0]) && (strcmp((s1), (s2)) == 0))


/* ---------------------------------------------------------------------- */
/* Function */
/* ---------------------------------------------------------------------- */

/* ********************************************************************** */
/**
 * @brief  Definition of yywrap.
 *
 * @return  1
 */
/* ********************************************************************** */
int yywrap(void)
{
	return 1;
}

/* ====================================================================== */
/**
 * @brief  Tiny copy of basename(3).
 *
 * @param[in] *name  (See man 3 basename).
 *
 * @return  (See man 3 basename).
 */
/* ====================================================================== */
static const char *
my_basename(const char * const name)
{
	const char *bn;

	assert(name != NULL);

	bn = strrchr(name, PATH_SEP);
	return (bn == NULL) ? name : bn+1;
}

/* ====================================================================== */
/**
 * @brief  Reset counter.
 */
/* ====================================================================== */
static void
reset_count(void)
{
	nc = nw = nl = 0;
}

/* ********************************************************************** */
/**
 * @brief  Main routine.
 *
 * @retval EXIT_SUCCESS  OK (success).
 * @retval EXIT_FAILURE  NG (failure).
 */
/* ********************************************************************** */
int
main(int argc, char *argv[])
{
	if ((argc == 2)
		&& (STREQ(argv[1], "-h") || STREQ(argv[1], "--help")))
	{
		(void) fprintf(stderr, "usage: %s [-h|--help]\n", my_basename(argv[0]));
		return EXIT_FAILURE;
	}

	reset_count();
	yylex();
	(void) printf("%lu\t%lu\t%lu\n",
	              (unsigned long) nl,
	              (unsigned long) nw,
	              (unsigned long) nc);

	return EXIT_SUCCESS;
}
