# -*- encoding: utf-8 -*-
require File.expand_path('../lib/modstamps/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["rtanc"]
  gem.email         = ["ryancavis@gmail.com"]
  gem.description   = %q{Provides basic, predictable auditing for ActiveRecords}
  gem.summary       = %q{Similar to the ActiveRecord::Timestamp module, this gem provides an audit trail for modifications to records.  Intended to work with Devise, it will also log the currently logged-in user.}
  gem.homepage      = "https://github.com/rtanc/modstamps"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "modstamps"
  gem.require_paths = ["lib"]
  gem.version       = Modstamps::VERSION
end
