# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yql_query/version"

Gem::Specification.new do |s|
  s.name        = "yql-query"
  s.version     = YqlQuery::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Agalloco"]
  s.email       = ["steve.agalloco@gmail.com"]
  s.homepage    = "https://github.com/spagalloco/yql-query"
  s.summary     = %q{A YQL Query generator}
  s.description = %q{A YQL Query generator}

  s.rubyforge_project = "yql-query"

  s.add_development_dependency('bundler', '~> 1.0')
  s.add_development_dependency('rake', '~> 0.9')
  s.add_development_dependency('rspec', '~> 2.6.0')
  s.add_development_dependency('yard', '~> 0.7')
  s.add_development_dependency('maruku', '~> 0.6')
  s.add_development_dependency('simplecov', '~> 0.4')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
