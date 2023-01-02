# frozen_string_literal: true

require "test_helper"

class TestGetargv < Minitest::Test
  def test_that_getargv_module_has_a_version_number
    refute_nil ::Getargv::VERSION
  end

  def test_that_getargv_module_has_get_argv_of_pid_method
    assert_respond_to(Getargv, :get_argv_of_pid)
  end

  def test_get_argv_of_pid_does_something_useful
    str = Getargv.get_argv_of_pid(Process.pid, false, 0)
    refute_nil str
    assert_match(/ruby/, str)
  end

  def test_get_argv_of_pid_enforces_arg_count
    assert_raises(ArgumentError, "no args") do
      Getargv.get_argv_of_pid
    end
    assert_raises(ArgumentError, "too many args") do
      Getargv.get_argv_of_pid(1, 2, 3, 4)
    end
  end

  def test_get_argv_of_pid_does_type_checking
    assert_raises(TypeError, "string for skip") do
      Getargv.get_argv_of_pid(Process.pid, false, "a")
    end
    assert_raises(TypeError, "nil for pid") do
      Getargv.get_argv_of_pid(nil)
    end
    assert_raises(TypeError, "string for pid") do
      Getargv.get_argv_of_pid("a")
    end
  end

  def test_that_getargv_module_has_get_argv_and_argc_of_pid_method
    assert_respond_to(Getargv, :get_argv_and_argc_of_pid)
  end

  def test_get_argv_and_argc_of_pid_does_something_useful
    ary = Getargv.get_argv_and_argc_of_pid Process.pid
    refute_nil ary
    refute_empty(ary)
    assert_match(/ruby/, ary.first)
  end

  def test_get_argv_and_argc_of_pid_enforces_arg_count
    assert_raises(ArgumentError, "no args") do
      Getargv.get_argv_and_argc_of_pid
    end
    assert_raises(ArgumentError, "too many args") do
      Getargv.get_argv_and_argc_of_pid(1, 2)
    end
  end

  def test_get_argv_and_argc_of_pid_does_type_checking
    assert_raises(TypeError, "nil for pid") do
      Getargv.get_argv_and_argc_of_pid(nil)
    end
    assert_raises(TypeError, "string for pid") do
      Getargv.get_argv_and_argc_of_pid("a")
    end
  end
end
