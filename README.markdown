
= Outpost

Outpost is a service monitoring tool written purely on Ruby. It's main focus is
to return a real-time service status using three structures: Scouts, Hooks and
Outposts.


== Disclaimer

This is a very initial code, so any interface may change in time and may contain
several bugs.

== Outposts

Outposts are Ruby classes that contains a DSL to express services dependencies.
Example:

    class WebOutpostExample < Outpost
      depends WebScout => "web page" do
        options :host => 'localhost', :port => 3000
        report :up, :response_code => 200
        report :up, :response_time => {:less_than => 100}
      end
    end

The above declared service will return a "up" status whenever the HTTP response
code is 200 and the service response time is bellow 100 milliseconds. 

Outpost relies on Scouts to do the determine a specific service's status,
such as MySQL connection or HTTP servers' response. 

=== Determining service's status

Outpost gather all status reports and consolidate them by returning the highest
priority status. So if only one scout report a <code>:down</code> status, the
overall system status will be :down. The status list and their priority is as
follows (from lowest to highest priority):

    :up
    :warning
    :unknown
    :down

To learn more about consolidation, check
<code>lib/outpost/scout/consolidation.rb</code> file, it's pretty
straightforward.

=== Running Outposts

You can check a service's status by running the method #check!:

    WebOutpostExample.new.check! # => :up

You can check more details about a service status by reading its messages:

    outpost = WebOutExample.new
    outpost.check!
    outpost.messages.each do |message|
        puts "#{message.scout_name} is #{message.status}: #{message.message}."
    end

You can find more examples in the <code>examples</code> folder.


== Scouts

Scouts are responsible to connect to the main service and return a basic status.
They receive options through initialization and must implement the
<code>execute</code> method, which should return some sort of response.

By plugging hooks, Scouts may return service status based on response code or
response time (included in the codebase). Example:

    class WebScout < Scout::Base
      add_hook Scout::Hooks::ResponseTime
      add_hook Scout::Hooks::ResponseCode

      attr_accessor :host, :port

      def initialize(options = {})
        @host     = options[:host] || 'localhost'
        @path     = options[:path] || '/'
        @port     = options[:port] || 80
      end

      def execute
        @message = Net::HTTP.get_response(@host, @path, @port).code.to_i
      rescue StandardError => e
        down!
        @message = e.to_s
      end
    end

You may write your own hook classes. To learn how to do that, read the following
subsection.


=== Writing Hooks

Hooks are a very simple classes that _must_ implement the build\_report method. 
It should return the service status depending on the rules. The example bellow
illustrates a very simple example:

    class ResponseCode < Scout::Hooks::Base

        def build_report(response, all_rules={})
          responses = each_rule(all_rules, :response_code) do |rule, status|
            if rule.is_a? Numeric or rule.is_a? String
              status if rule.to_i == response.to_i
            else
              :unknown
            end
          end
        end

    end

The <code>build\_report</code> receives the response returned by the Scout and
all the rules specified on an Outpost. It is as follows:

    {
        :response_code => {
            200 => :down
        }
    }

So <code>each\_rule</code> is a helper method that will iterate over all rules.


