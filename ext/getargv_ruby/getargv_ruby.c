#include "getargv_ruby.h"

// https://ruby-doc.org/3.2.0/extension_rdoc.html

VALUE rb_mGetargv;

/*
 *  call-seq:
 *     Getargv.get_argv_of_pid(pid)                       -> String
 *     Getargv.get_argv_of_pid_as_string(pid)             -> String
 *     Getargv.get_argv_of_pid(pid, nuls)                 -> String
 *     Getargv.get_argv_of_pid_as_string(pid, nuls)       -> String
 *     Getargv.get_argv_of_pid(pid, nuls, skip)           -> String
 *     Getargv.get_argv_of_pid_as_string(pid, nuls, skip) -> String
 *
 *  Returns the arguments for the given process id as a string. If the second
 *  arg is true: replace nul separators with spaces for human consumption. If
 *  the third arg is provided, skip ahead the returned string by the given
 *  number of leading arguments.
 *
 *  Getargv::get_argv_of_pid_as_string is an alias for Getargv::get_argv_of_pid.
 *
 *  Examples
 *
 *    Getargv.get_argv_of_pid(Process.pid)           #=> "ruby\x00-e..."
 *    Getargv.get_argv_of_pid(Process.pid(),true)    #=> "ruby -e..."
 *    Getargv.get_argv_of_pid(Process.pid(),false,1) #=> "-e..."
 */
static VALUE ruby_get_argv_of_pid(int argc, VALUE *argv, VALUE self) {
  rb_check_arity(argc, 1, 3);
  Check_Type(argv[0], T_FIXNUM);
  rb_pid_t pid = NUM2PIDT(argv[0]);
  bool nuls = false;
  uint skip = 0;

  if (argc > 1)
    nuls = RB_TEST(argv[1]);
  if (argc > 2 && !NIL_P(argv[2])) {
    Check_Type(argv[2], T_FIXNUM);
    skip = NUM2UINT(argv[2]);
  }

  struct GetArgvOptions options = {.pid = pid, .skip = skip, .nuls = nuls};
  struct ArgvResult result;
  if (!get_argv_of_pid(&options, &result)) {
    rb_sys_fail(0); // uses errno
  }

  // assemble result ruby string, this copies :(
  VALUE retVal = rb_str_new(result.start_pointer,
                            1 + result.end_pointer - result.start_pointer);
  free_ArgvResult(&result); // ruby copied data, can free buffer now

  return retVal;
}

/*
 *  call-seq:
 *     Getargv.get_argv_and_argc_of_pid(pid)             -> [String]
 *     Getargv.get_argv_of_pid_as_array(pid)             -> [String]
 *
 *  Returns the arguments for the given process id as an array of strings.
 *
 *  Getargv::get_argv_of_pid_as_array is an alias for Getargv::get_argv_and_argc_of_pid.
 *
 *  Examples
 *
 *    Getargv.get_argv_and_argc_of_pid(Process.pid)      #=> ["ruby,"-e",...]
 */
static VALUE ruby_get_argv_and_argc_of_pid(VALUE self, VALUE rPid) {
  Check_Type(rPid, T_FIXNUM);
  rb_pid_t pid = NUM2PIDT(rPid);

  struct ArgvArgcResult result;
  if (!get_argv_and_argc_of_pid(pid, &result)) {
    rb_sys_fail(0); // uses errno
  }

  VALUE ary = rb_ary_new_capa(result.argc);
  for (size_t i = 0; i < result.argc; i++) {
    // assemble result ruby string, this copies :(
    rb_ary_push(ary, rb_str_new_cstr(result.argv[i]));
  }
  // ruby copied data, can free buffers now
  free_ArgvArgcResult(&result);

  return ary;
}

void Init_getargv_ruby(void) {
  rb_mGetargv = rb_define_module("Getargv");

  rb_define_module_function(rb_mGetargv, "get_argv_of_pid", ruby_get_argv_of_pid, -1);
  // Getargv::get_argv_of_pid_as_string is an alias for Getargv::get_argv_of_pid.
  rb_define_alias(rb_singleton_class(rb_mGetargv),  "get_argv_of_pid_as_string", "get_argv_of_pid");

  rb_define_module_function(rb_mGetargv, "get_argv_and_argc_of_pid", ruby_get_argv_and_argc_of_pid, 1);
  // Getargv::get_argv_of_pid_as_array is an alias for Getargv::get_argv_and_argc_of_pid.
  rb_define_alias(rb_singleton_class(rb_mGetargv),  "get_argv_of_pid_as_array", "get_argv_and_argc_of_pid");
}
