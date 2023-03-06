# frozen_string_literal: true

require "test_helper"

# https://ruby-doc.org/3.2.0/gems/minitest/Minitest/Assertions.html

class TestGetargv < Minitest::Test
  def test_that_getargv_module_has_a_version_number
    refute_nil ::Getargv::VERSION
  end

  def test_that_getargv_module_has_get_argv_of_pid_method
    assert_respond_to(Getargv, :get_argv_of_pid)
  end

  def test_get_argv_of_pid_does_something_useful
    str = Getargv.get_argv_of_pid(Process.pid, Encoding.default_external, false, 0)
    refute_nil str
    assert_match(/ruby/, str)
  end

  def test_get_argv_of_pid_enforces_arg_count
    assert_raises(ArgumentError, "no args") do
      Getargv.get_argv_of_pid
    end
    assert_raises(ArgumentError, "too few args") do
      Getargv.get_argv_of_pid(1)
    end
    assert_raises(ArgumentError, "too many args") do
      Getargv.get_argv_of_pid(1, 2, 3, 4, 5)
    end
  end

  def test_get_argv_of_pid_does_type_checking
    assert_raises(TypeError, "string for skip") do
      Getargv.get_argv_of_pid(Process.pid, false, "a")
    end
    assert_raises(TypeError, "nil for pid") do
      Getargv.get_argv_of_pid(nil, Encoding.default_external)
    end
    assert_raises(TypeError, "string for pid") do
      Getargv.get_argv_of_pid("a", Encoding.default_external)
    end
    assert_raises(TypeError, "nil for enc") do
      Getargv.get_argv_of_pid(Process.pid, nil)
    end
    assert_raises(ArgumentError, "string for enc") do
      Getargv.get_argv_of_pid(Process.pid, "nil")
    end
    assert_raises(TypeError, "number for enc") do
      Getargv.get_argv_of_pid(Process.pid, 1)
    end
  end

  def test_that_getargv_module_has_get_argv_and_argc_of_pid_method
    assert_respond_to(Getargv, :get_argv_and_argc_of_pid)
  end

  def test_get_argv_and_argc_of_pid_does_something_useful
    ary = Getargv.get_argv_and_argc_of_pid(Process.pid, Encoding.default_external)
    refute_nil ary
    refute_empty(ary)
    assert_match(/ruby/, ary.first)
  end

  def test_get_argv_and_argc_of_pid_enforces_arg_count
    assert_raises(ArgumentError, "no args") do
      Getargv.get_argv_and_argc_of_pid
    end
    assert_raises(ArgumentError, "too few args") do
      Getargv.get_argv_and_argc_of_pid(1)
    end
    assert_raises(ArgumentError, "too many args") do
      Getargv.get_argv_and_argc_of_pid(1, 2, 3)
    end
  end

  def test_get_argv_and_argc_of_pid_does_type_checking
    assert_raises(TypeError, "nil for pid") do
      Getargv.get_argv_and_argc_of_pid(nil, Encoding.default_external)
    end
    assert_raises(TypeError, "string for pid") do
      Getargv.get_argv_and_argc_of_pid("a", Encoding.default_external)
    end

    assert_raises(TypeError, "nil for enc") do
      Getargv.get_argv_and_argc_of_pid(Process.pid, nil)
    end
    assert_raises(ArgumentError, "string for enc") do
      Getargv.get_argv_and_argc_of_pid(Process.pid, "nil")
    end
    assert_raises(TypeError, "number for enc") do
      Getargv.get_argv_and_argc_of_pid(Process.pid, 1)
    end
  end
end
