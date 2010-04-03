require 'rubygems'
require 'spec'

begin
  require 'ruby-debug'
rescue LoadError
  # We are not loud if ruby-debug fails because of ruby 1.9
end

require File.expand_path(File.dirname(__FILE__) + '/../lib/outpost')

# Load everything...
include Outpost

Spec::Runner.configure do |config|
end
