# frozen_string_literal: true

require_relative "lib/uk/hs_code/version"

Gem::Specification.new do |spec|
  spec.name = "uk-hs_code"
  spec.version = Uk::HsCode::VERSION
  spec.authors = ["Mateusz Michalski"]
  spec.email = ["enigmatt.priv@gmail.com"]

  spec.summary = "Enables communication with Trade Tariff Public API V2."
  spec.description = "Trade Tariff Public API V2 communicator."
  spec.homepage = "https://github.com/enigmatt-pl/uk-hs_code"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://github.com/enigmatt-pl/uk-hs_code/"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
