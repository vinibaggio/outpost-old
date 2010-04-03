require 'outpost/probe/errors'

module Outpost
  module Probe

    # Probe rule was called, but there are no handlers
    # that support the specified rule.
    class UnknownHandlerError < OutpostError; end

    # Probe was asked to add a handler, but it doesn't
    # respond to the necessary methods.
    class InvalidHandlerError < OutpostError; end

    module StatusHandler
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

      module ClassMethods

        # Add a report a status to the rules handler
        def report(status, rule)
          rule_key = rule.keys.first
          rule_params = rule[rule_key]

          @@reports ||= []
          @@reports << {:status => status, :rule => rule_key, :rule_params => rule_params}
        end

        # Register a rule handler in the probe
        def register_rule_handler(*rule_handlers)
          rule_handlers.each do |rule_handler|
            if rule_handler.respond_to?(:rule_name) and rule_handler.respond_to?(:handle)
              @@handlers ||= {}
              @@handlers[rule_handler.rule_name] = rule_handler
            else
              raise InvalidHandlerError, "Invalid handler: #{rule_handler}"
            end
          end
        end

        def handlers
          @@handlers.dup
        end

        alias register_rule_handlers register_rule_handler
      end

      module InstanceMethods

        def measure_status(&block)
          status_list = []
          @@reports.each do |report|
            @@handlers[report[:rule]].tap do |handler|
              status_list << report[:status] if handler.handle(@@report[:rule_params], &block)
            end
          end
          status_list
        end

      end

    end

  end
end
