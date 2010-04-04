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
        @@reports = []
        @@handlers = {}

        # Add a report a status to the rules handler
        def report(status, rule)
          rule_key = rule.keys.first
          rule_params = rule[rule_key]

          @@reports << {:status => status, :rule => rule_key, :rule_params => rule_params}
        end

        # Register a rule handler in the probe
        def register_rule_handler(*rule_handlers)
          rule_handlers.each do |rule_handler_class|
            rule_handler = rule_handler_class.new

            if valid_handler?(rule_handler)
              @@handlers[rule_handler.rule_name] = rule_handler
            else
              raise InvalidHandlerError, "Invalid handler: #{rule_handler}"
            end
          end
        end

        def handlers
          @@handlers
        end

        def reports
          @@reports
        end

        alias register_rule_handlers register_rule_handler

        protected
          def valid_handler?(handler)
            handler.respond_to?(:rule_name) and handler.respond_to?(:handle) and handler.rule_name.is_a? Symbol
          end
      end

      module InstanceMethods

        # TODO: Return a Report object instead of pure symbols
        def measure_status(&block)
          status_to_report = nil
          self.class.reports.each do |report|
            self.class.handlers[report[:rule]].tap do |handler|
              status_to_report = report[:status] if handler.handle(report[:rule_params], &block)
            end
          end
          status_to_report
        end

      end

    end

  end
end
