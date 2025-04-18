# frozen_string_literal: true

require_relative 'lib/lineworks/client/version'

Gem::Specification.new do |spec|
  spec.name = 'lineworks'
  spec.version = Lineworks::VERSION
  spec.authors = ['Katsuyoshi Ito']
  spec.email = ['kito@itosoft.com']

  spec.summary = 'This gem is to use access to LINE WORKS API from Ruby.'
  spec.description = 'This gem is to use access to LINE WORKS API from Ruby.'
  spec.homepage = 'https://github.com/katsuyoshi/lineworks-ruby'
  spec.license = 'Apache-2.0'
  spec.required_ruby_version = '>= 2.6.0'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  # spec.bindir = "exe"
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'line-bot-api', '~> 1.28.0'
  spec.add_dependency 'openssl', '~> 3.2'
  spec.add_dependency 'jwt', '~> 2.7.1'
  spec.add_dependency "activesupport", ">= 5.0"
  
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
