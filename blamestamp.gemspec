$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "blamestamp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blamestamp"
  s.version     = Blamestamp::VERSION
  s.authors     = ["rtanc"]
  s.email       = ["ryancavis@gmail.com"]
  s.homepage    = "https://github.com/rtanc/blamestamp"
  s.summary     = "Basic, predictable user/datetime blaming for ActiveRecords"
  s.description = "Similar to ActiveRecord::Timestamp, this gem provides a blame datetime and user for create/update modifications to records.  Configured models will be blamed when creating or updating, and the blame can cascade to associated models on create, update or delete.  Currently, this gem is intended for use with Devise."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency('rails', '>= 3.0.0')
  s.add_dependency('devise', '>= 2.0.0')
  s.add_dependency('activerecord', '>= 3.0.0')
  s.add_dependency('activemodel', '>= 3.0.0')
  s.add_dependency('activesupport', '>= 3.0.0')

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "devise"
end
