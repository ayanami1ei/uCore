#ifndef STDIO_H
#define STDIO_H

#include <stdarg.h>

#define stdin 0
#define stdout 1
#define stderr 2

int vprintf(const char *fmt, va_list ap);
int printf(const char *fmt, ...);

#endif