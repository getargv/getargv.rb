# frozen_string_literal: true

require "yaml"
require_relative "lib/getargv_ruby/version"
ruby_version = YAML.load_file(".standard.yml")["ruby_version"]

Gem::Specification.new do |spec|
  spec.name = "getargv"
  spec.version = Getargv::VERSION
  spec.authors = ["Camden Narzt"]
  spec.email = ["getargv@narzt.cam"]

  spec.summary = "This gem allows you to query the arguments of other processes on macOS."
  spec.description = <<-EOF
  Getargv is a gem that allows you to query the arguments of other processes as
  an array or string. This gem only supports macOS because the KERN_PROCARGS2
  sysctl only exists in xnu kernels, BSD or Linux users should just read
  /proc/$PID/cmdline which is much easier and faster, Solaris users should use
  pargs.
  EOF
  spec.homepage = "https://getargv.narzt.cam/"
  spec.license = "BSD-3-Clause"
  spec.required_ruby_version = ">= #{ruby_version}.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/getargv/getargv_ruby"
  spec.metadata["changelog_uri"] = "https://github.com/getargv/getargv_ruby/blob/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/getargv/getargv_ruby/issues"
  spec.metadata["funding_uri"] = "https://github.com/sponsors/CamJN"
  spec.metadata["documentation_uri"] = "https://rubydoc.info/gems/getargv/Getargv"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "ext"]
  spec.extensions = ["ext/getargv_ruby/extconf.rb"]
  spec.platform = 'darwin'

  spec.extra_rdoc_files = Dir["README.md", "ext/*/*.c", "lib/*/*.rb", "ext/*.c", "lib/*.rb"]
  spec.rdoc_options << "-o doc"
  spec.rdoc_options << "-T" << "rails"
  # spec.rdoc_options << "-T" << "direct"
  # spec.rdoc_options << "-T" << "shtml"
  spec.rdoc_options << "--format=sdoc"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
