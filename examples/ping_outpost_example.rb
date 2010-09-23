$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../scouts')

require 'outpost'
require 'ping_scout'

class PingOutpostExample < Outpost

  depends PingScout => "host" do
    options :host => 'www.google.com'
    report :up, :response_code => true
  end

end

loop do
  outpost = PingOutpostExample.new
  puts "\nThe system is #{outpost.check!}!"

  outpost.messages.each do |message|
    puts "#{message.scout_name} is #{message.status}: #{message.message}."
  end

  sleep 1
end
