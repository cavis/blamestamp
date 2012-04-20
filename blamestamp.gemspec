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
  s.summary     = "Provides basic, predictable auditing for ActiveRecords."
  s.description = "Similar to ActiveRecord::Timestamp, this gem provides a blame for create/update modifications to records.  Intended to work with Devise, it will also log the currently logged-in user for the create/update action."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "devise"
end
