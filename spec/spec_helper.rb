require 'simplecov'
SimpleCov.start do
  add_group 'YQL Query', 'lib/yql_query'
  add_group 'Specs', 'spec'
end

require File.expand_path('../../lib/yql_query', __FILE__)

require 'rspec'