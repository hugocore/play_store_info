$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'play_store_info/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'play_store_info'
  s.version     = PlayStoreInfo::VERSION
  s.authors     = ['Hugo Sequeira']
  s.email       = ['hugoandresequeira@gmail.com']
  s.homepage    = 'TODO'
  s.summary     = 'Simple Google Play store parser'
  s.description = 'Simple Google Play store parser'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.2.3'
  s.add_dependency 'metainspector'
end
