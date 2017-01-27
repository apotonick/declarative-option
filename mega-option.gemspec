require File.expand_path('../lib/mega/option/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nick Sutterer"]
  gem.email         = ["apotonick@gmail.com"]
  gem.description   = %q{Dynamic options.}
  gem.summary       = %q{Dynamic options to evaluate at runtime.}
  gem.homepage      = "https://github.com/apotonick/mega-option"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mega-option"
  gem.require_paths = ["lib"]
  gem.version       = Mega::Option::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
end
