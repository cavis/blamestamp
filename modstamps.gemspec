$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "modstamps/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "modstamps"
  s.version     = Modstamps::VERSION
  s.authors     = ["rtanc"]
  s.email       = ["ryancavis@gmail.com"]
  s.homepage    = "https://github.com/rtanc/modstamps"
  s.summary     = "Provides basic, predictable auditing for ActiveRecords."
  s.description = "Similar to the ActiveRecord::Timestamp module, this gem provides an audit trail for modifications to records.  Intended to work with Devise, it will also log the currently logged-in user."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "devise"
end
