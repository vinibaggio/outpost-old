require 'rubygems'
require 'spec'

begin
  require 'ruby-debug'
rescue LoadError
end

require File.expand_path(File.dirname(__FILE__) + '/../lib/outpost')

# Load everything...
include Outpost
