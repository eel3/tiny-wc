# @brief   tiny-wc Makefile for Unix like environment.
# @author  eel3
# @date    2022-02-12
#
# @note
# - GCC 4.6.3 on Ubuntu 12.04.4 LTS 32bit

app        := tiny-wc
CFLAGS     += -Wall -ansi -pedantic -Wno-unused-function -Wno-implicit-function-declaration

LEX        := flex

.PHONY: all
all: $(app)

.PHONY: clean
clean:
	$(RM) $(app) $(app).c
