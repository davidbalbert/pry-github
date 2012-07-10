# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pry-github/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Albert"]
  gem.email         = ["davidbalbert@gmail.com"]
  gem.description   = %q{Make pry play nice with GitHub}
  gem.summary       = %q{Make pry play nice with GitHub}
  gem.homepage      = "https://github.com/davidbalbert/pry-github"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pry-github"
  gem.require_paths = ["lib"]
  gem.version       = PryGithub::VERSION

  gem.add_dependency('pry')
  gem.add_dependency('grit', '~> 2.5.0')

  gem.add_development_dependency('pry-debundle')
end
