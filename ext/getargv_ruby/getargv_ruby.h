#ifndef GETARGV_RUBY_H
#define GETARGV_RUBY_H

#include <ruby.h>
#include <ruby/encoding.h>
#include <libgetargv.h>
#include <stddef.h>
#include <sys/errno.h>

#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L)
#if (__STDC_VERSION__ < 202311L)
  #include <stdbool.h>
#endif
#else
typedef enum { false, true } bool;
#endif

void Init_getargv_ruby(void);

#endif /* GETARGV_RUBY_H */
