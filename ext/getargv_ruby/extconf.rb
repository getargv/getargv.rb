# frozen_string_literal: true

require "mkmf"

def darwin_check
  require "pathname"
  src = RbConfig::CONFIG["srcdir"] || __dir__
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

unless have_library("getargv", "get_argv_of_pid", "libgetargv.h")
  abort "libgetargv is missing, please install libgetargv."
end

create_makefile("getargv_ruby/getargv_ruby")
