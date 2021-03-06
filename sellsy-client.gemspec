require_relative 'lib/sellsy/version'

Gem::Specification.new do |spec|
  spec.name          = "sellsy-client"
  spec.version       = Sellsy::VERSION
  spec.authors       = ["Jens Stammers", "Guirec Corbel", "François Guilbert", "Jean-Baptiste Vilain"]
  spec.email         = ["jbvilain@gmail.com"]

  spec.summary       = "A Ruby gem wrapping a REST client for the Sellsy API"
  spec.description   = "To be completed"
  spec.homepage      = "https://github.com/hotentic/sellsy-client"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "multi_json", "~> 1.11"
  spec.add_dependency "rest-client", "~> 2.0", ">= 2.0.2"
end
