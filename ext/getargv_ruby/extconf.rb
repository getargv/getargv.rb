# frozen_string_literal: true

temporary_hack = "delete this line when https://github.com/testdouble/standard/pull/498 lands in a release" # rubocop:disable Lint/UselessAssignment

def darwin_check
  require "pathname"
  src = $srcdir || __dir__ # standard:disable Style/GlobalVars
  require_relative Pathname.new("#{src}/../../lib/getargv_ruby/version.rb").realpath.to_s
  abort <<EOF unless RUBY_PLATFORM.include?("darwin")

   getargv can only work on macOS, fix your Gemfile like this:

   gem "getargv", "~> #{Getargv::VERSION}", platforms: :ruby, install_if: RbConfig::CONFIG["host_os"].include?("darwin")

EOF
end

darwin_check
arch_dir = RbConfig::CONFIG["rubyarchhdrdir"]
# `xcode-select --print-path`/SDKs/MacOSX.sdk/System/Library/Frameworks/Ruby.framework/Versions/Current/Headers/ruby.h
unless File.exist?(arch_dir)
  arch_dir.sub!(RUBY_PLATFORM.split("-").last, Dir.entries(File.dirname(arch_dir)).reject { |d| d.start_with?(".", "ruby") }.first.split("-").last)
end

require "mkmf"

unless have_library("getargv", "get_argv_of_pid", "libgetargv.h")
  abort "libgetargv is missing, please install libgetargv."
end

create_makefile("getargv_ruby/getargv_ruby")
