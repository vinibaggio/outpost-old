require 'outpost/errors'

module Outpost
  module Probe
   
    class UnknownHandlerError < OutpostError;
    # Outpost probes report statuses to their masters.
    #
    # When a probe is launched, it will poke the service in question
    # and will report a status to its master, defined by the +report+
    # rules.
    # 
    # Examples:
    # class DatabaseProbe < Outpost::Probe::Base
    #   report :up,       :response_time => {:less_than => 3000}
    #   report :warning,  :response_time => {:more_than => 3000, :less_than => 5000}
    #   report :down,     :response_time => {:more_than => 5000}
    #   report :down,     :response_code => :error
    # end
    # 
    # Available statuses are:
    # <tt>:up</tt> - Service up.
    # <tt>:warning</tt> - Service is up but something is not completely right.
    # <tt>:down</tt> - Service is down.
    #
    # Probes report statuses using a set of rules. Those rules are mainly the following:
    # <tt>:response_time</tt> - Measure a dummy request to a service
    # <tt>:response_code</tt> - Get the response code of a dummy request to a service
    #
    # See rules handlers for more information.
    #
    module StatusHandler
      
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        attr_accessor :reports, :handlers

        # Add a report a status to the rules handler 
        def report(status, rule)
          rule_key = rule.keys.first
          rule_params = rule[rule_key]

          @reports ||= []
          @reports << {:status => status, :rule => rule_key, :rule_params => rule_params}
        end

        def register_rule_handler(rule_handler)
          if rule.respond_to?(:rule_name) and rule.respond_to?(:handle)
            @handlers ||= {}
            @handlers[rule_handler.rule_name] = rule_handler
          end
        end
      end
      
      module InstanceMethods

        def measure_status(&block)
          status_list = []
          self.class.reports.each do |report|
            handler = self.class.handlers[report[:rule]]
            status << report[:status] if handler.handle(report[:rule_params], block)
          end
          status
        end


      end
    end


  end
end
