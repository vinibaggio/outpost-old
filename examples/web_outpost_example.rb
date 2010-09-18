$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../scouts')

require 'outpost'
require 'web_scout'

class WebOutpostExample < Outpost
  # name "Web Site #1"

  depends WebScout => "web page" do
    options :host => 'localhost', :port => 80
    report :up, :response_code => 200
    report :up, :response_time => {:less_than => 2000}
  end
end

puts "The system is #{WebOutpostExample.check!.inspect}!"
