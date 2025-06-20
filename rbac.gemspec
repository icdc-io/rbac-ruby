# frozen_string_literal: true

require_relative "lib/rbac/version"

Gem::Specification.new do |spec|
  spec.name = "rbac-ruby"
  spec.version = Rbac::VERSION
  spec.authors = ["Aliaksei Hrechushkin"]
  spec.email = ["ahrechushkin@ibagroup.eu"]

  spec.summary               = "Role-based access control gem."
  spec.description           = "Use dynamicly configurable RBAC system to control access to your application."
  spec.required_ruby_version = ">= 3.2.0"
  spec.homepage              = "https://icdc.io"
  spec.licenses              = ["Apache-2.0"]

  spec.metadata["source_code_uri"]       = "https://github.com/icdc-io/rbac-ruby"
  spec.metadata["changelog_uri"]         = "https://github.com/icdc-io/rbac-ruby/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 6.1", "< 9.0"
  spec.add_dependency "activesupport", ">= 6.1", "< 9.0"
  spec.add_dependency "concurrent-ruby", "1.3.4"
  spec.add_dependency "yaml", "~> 0.2.0"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
