# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack-referrals/version"

Gem::Specification.new do |s|
  s.name        = "rack-referrals"
  s.version     = Rack::Referrals::VERSION
  s.authors     = ["Kali Donovan"]
  s.email       = ["kali@deviantech.com"]
  s.homepage    = ""
  s.summary     = %q{Extracts referring search engine info.}
  s.description = %q{If the user clicked through from a search engine, this middleware will detect the engine used and the terms searched.}

  s.rubyforge_project = "rack-referrals"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "minitest"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "rake"
  s.add_dependency 'rack'
end
