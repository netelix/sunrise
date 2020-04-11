require_relative 'lib/sunrise/version'
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "sunrise"
  spec.version       = Sunrise::VERSION
  spec.authors       = ["Alexis Panet"]
  spec.email         = ["netelix@gmail.com"]

  spec.summary       = "sunrise"
  spec.homepage      = "http://google.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.1")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://google.com"
  spec.metadata["changelog_uri"] = "http://google.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir["{app,config,lib}/**/*", "CHANGELOG.md", "MIT-LICENSE", "README.md"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
