# frozen_string_literal: true

require "bump/tasks"
require "bundler/gem_tasks"
require "rake/extensiontask"
require "rake/testtask"
require "rdoc/task"
require "sdoc"
require "standard/rake"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task default: %i[clobber compile test standard]
task build: :compile

Rake::ExtensionTask.new("getargv_ruby") do |ext|
  ext.lib_dir = "lib/getargv_ruby"
end

RDoc::Task.new do |rdoc|
  rdoc.main = "README.md"
  rdoc.rdoc_dir = "doc"
  rdoc.options << "--format=sdoc"
  rdoc.template = "rails"
  rdoc.rdoc_files.include("ext/*/*.c", "lib/*/*.rb", "lib/*.rb")
end

namespace :dev do
  desc "generate a Makefile"
  task :makefile do
    ruby "ext/getargv_ruby/extconf.rb"
  end
  CLOBBER << "Makefile"

  compilation_db_path = "ext/getargv_ruby/compile_commands.json"
  desc "generate compilation database for language server"
  task database: :makefile do
    system "bear", "--output", compilation_db_path, "--", "make", "getargv_ruby.o"
  end
  CLOBBER << compilation_db_path
end

CLEAN.concat [
  "ext/getargv_ruby/.cache",
  "getargv_ruby.o",
  "mkmf.log"
]
