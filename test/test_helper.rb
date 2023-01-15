# frozen_string_literal: true

ENV["RBS_TEST_TARGET"] = "Getargv::*"
require "rbs/test/setup"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "getargv_ruby"

require "minitest/autorun"
require "minitest/pride"
