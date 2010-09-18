$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../scouts')

require 'outpost'
require 'web_scout'
require 'mysql_scout'

class WebAndDatabaseOutpostExample < Outpost
  # name "Web Site #1"

  depends WebScout => "Web Page" do
    options :host => 'localhost', :port => 80
    report :up, :response_code => 200
  end

  depends MysqlScout => "MySQL" do
    options :host => 'localhost', :port => 3306
    report :up, :response_code => 0
    report :up, :response_time => {:less_than => 2000}
  end
end

while true do
  outpost = WebAndDatabaseOutpostExample.new
  puts "The system is #{outpost.check!}!"

  outpost.messages.each do |message|
    print "#{message.scout_name} is #{message.status}: #{message.message}.\n"
  end

  sleep 1
end

