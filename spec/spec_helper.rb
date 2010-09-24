require 'rubygems'
require 'bundler'

Bundler.setup :test

require 'spec'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')

require 'outpost'

Spec::Runner.configure do |config| # Rspec 1.3.0
  
  def server(string, options={})
    Server::Configuration.new(string, options)
  end
  
end