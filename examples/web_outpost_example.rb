$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../scouts')

require 'outpost'
require 'web_scout'

class WebOutpostExample < Outpost
  depends WebScout => "web page" do
    options :host => 'localhost', :port => 3000
    report :up, :response_code => 200
    report :up, :response_time => {:less_than => 100}
  end
end

loop do
  outpost = WebOutpostExample.new
  puts "The system is #{outpost.check!}!"

  outpost.messages.each do |message|
    puts "#{message.scout_name} is #{message.status}: #{message.message}."
  end

  sleep 1
end

