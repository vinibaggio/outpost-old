require 'rubygems'

require 'spec'
require 'ruby-debug'

require File.expand_path(File.dirname(__FILE__) + '/../lib/outpost')

include Outpost::Probe::RulesHandler

Spec::Runner.configure do |config|
end
