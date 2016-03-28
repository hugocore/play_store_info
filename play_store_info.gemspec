# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'play_store_info/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'play_store_info'
  spec.version     = PlayStoreInfo::VERSION
  spec.authors     = ['Hugo Sequeira']
  spec.email       = ['hugoandresequeira@gmail.com']

  spec.homepage    = 'TODO'
  spec.summary     = 'Simple Google Play store parser'
  spec.description = 'Simple Google Play store parser'
  spec.license     = 'MIT'

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.files         = 'git ls-files -z'.split("\x0").reject { |f| f.match(%r{^(spec)/}) }

  spec.add_dependency 'metainspector', '~> 5.1.1'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rubocop', '~> 0.35'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.3'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'pry-debugger'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 1.22'
end
