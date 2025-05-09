#include "getargv_ruby.h"

// https://ruby-doc.org/3.2.0/extension_rdoc.html

static VALUE rb_mGetargv;

/*
 * call-seq:
 *     Getargv.get_argv_of_pid(pid, enc)                       -> String
 *     Getargv.get_argv_of_pid_as_string(pid, enc)             -> String
 *     Getargv.get_argv_of_pid(pid, enc, nuls)                 -> String
 *     Getargv.get_argv_of_pid_as_string(pid, enc, nuls)       -> String
 *     Getargv.get_argv_of_pid(pid, enc, nuls, skip)           -> String
 *     Getargv.get_argv_of_pid_as_string(pid, enc, nuls, skip) -> String
 *
 * Returns the arguments for the given process id as a string with the
 * specified encoding. If the third arg is +true+: replace +nul+ separators with
 * +space+ for human consumption. If the fourth arg is provided, skip ahead the
 * returned string by the given number of leading arguments.
 *
 * Getargv::get_argv_of_pid_as_string is an alias for Getargv::get_argv_of_pid.
 *
 * === Examples:
 *
 *    Getargv.get_argv_of_pid(Process.pid, Encoding.default_external)           #=> "ruby\x00-e..."
 *    Getargv.get_argv_of_pid(Process.pid, Encoding.default_external, true)     #=> "ruby -e..."
 *    Getargv.get_argv_of_pid(Process.pid, Encoding.default_external, false, 1) #=> "-e..."
 */
static VALUE ruby_get_argv_of_pid(int argc, const VALUE *argv, VALUE self) {
  rb_check_arity(argc, 2, 4);
  Check_Type(argv[0], T_FIXNUM);
  rb_pid_t pid = NUM2PIDT(argv[0]);
  bool nuls = false;
  uint skip = 0;
  rb_encoding *encoding = rb_to_encoding(argv[1]);

  if (argc > 2)
    nuls = RB_TEST(argv[2]);
  if (argc > 3 && !NIL_P(argv[3])) {
    Check_Type(argv[3], T_FIXNUM);
    skip = NUM2UINT(argv[3]);
  }

  struct GetArgvOptions options = {.pid = pid, .skip = skip, .nuls = nuls};
  struct ArgvResult result;
  if (!get_argv_of_pid(&options, &result)) {
    rb_sys_fail(0); // uses errno
  }

  // assemble result ruby string, this copies :(
  VALUE retVal =
      rb_enc_str_new(result.start_pointer,
                     1 + result.end_pointer - result.start_pointer, encoding);
  free_ArgvResult(&result); // ruby copied data, can free buffer now

  return retVal;
}

/*
 * call-seq:
 *     Getargv.get_argv_and_argc_of_pid(pid, enc) -> [String]
 *     Getargv.get_argv_of_pid_as_array(pid, enc) -> [String]
 *
 * Returns the arguments for the given process id as an array of strings with the specified encoding.
 *
 * Getargv::get_argv_of_pid_as_array is an alias for Getargv::get_argv_and_argc_of_pid.
 *
 * === Examples:
 *
 *    Getargv.get_argv_and_argc_of_pid(Process.pid, Encoding.default_external) #=> ["ruby,"-e",...]
 */
static VALUE ruby_get_argv_and_argc_of_pid(VALUE self, VALUE rPid, VALUE enc) {
  Check_Type(rPid, T_FIXNUM);
  rb_pid_t pid = NUM2PIDT(rPid);

  rb_encoding *encoding = rb_to_encoding(enc);

  struct ArgvArgcResult result;
  if (!get_argv_and_argc_of_pid(pid, &result)) {
    rb_sys_fail(0); // uses errno
  }

  VALUE ary = rb_ary_new_capa(result.argc);
  for (size_t i = 0; i < result.argc; i++) {
    // assemble result ruby string, this copies :(
    rb_ary_push(ary, rb_enc_str_new_cstr(result.argv[i], encoding));
  }
  // ruby copied data, can free buffers now
  free_ArgvArgcResult(&result);

  return ary;
}

void Init_getargv_ruby(void) {
  rb_mGetargv = rb_define_module("Getargv");

  rb_define_module_function(rb_mGetargv, "get_argv_of_pid", ruby_get_argv_of_pid, -1);

  // Getargv::get_argv_of_pid_as_string is an alias for Getargv::get_argv_of_pid.
  rb_define_alias(rb_singleton_class(rb_mGetargv), "get_argv_of_pid_as_string", "get_argv_of_pid");

  rb_define_module_function(rb_mGetargv, "get_argv_and_argc_of_pid", ruby_get_argv_and_argc_of_pid, 2);

  // Getargv::get_argv_of_pid_as_array is an alias for Getargv::get_argv_and_argc_of_pid.
  rb_define_alias(rb_singleton_class(rb_mGetargv), "get_argv_of_pid_as_array", "get_argv_and_argc_of_pid");
}
