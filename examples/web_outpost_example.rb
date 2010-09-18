$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../scouts')

require 'outpost'
require 'web_scout'

class WebOutpostExample < Outpost
  # name "Web Site #1"

  depends WebScout => "web page" do
    options :host => 'localhost', :port => 3000
    report :up, :response_code => 200
    report :up, :response_time => {:less_than => 100}
  end
end

while true do
  outpost = WebOutpostExample.new
  puts "The system is #{outpost.check!}!"

  outpost.messages.each do |message|
    print "#{message.scout_name} is #{message.status}: #{message.message}.\n"
  end

  sleep 1
end

