require 'rubygems'
require 'bundler'

Bundler.setup :test

require 'spec'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib/')

require 'outpost'
