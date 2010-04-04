
module Outpost
  module Probe

    # Describes the result of all handlers, returning the worst
    # status of all entries added to it. It also stores the
    # message related with the worst statuses.
    #
    # It also has, in +all_messages+, all the messages returned
    # by the handlers, if they report anything.
    #
    # So, if multiple handlers signal a :down status, report_messages
    # will hold all the failing messages.
    class Report
      attr_accessor :status
      attr_accessor :report_messages
      attr_accessor :all_messages

      STATUS_MAP = {:up => 0, :warning => 1, :down => 3}.freeze

      def initialize
        @status = :up
        @all_messages = []
        @report_messages = []
      end

      def add(report, handler, &block)
        last_message = handler.message if handler.respond_to? :message
        new_status = report[:status]

        if equal_or_worse? new_status
          append_report_messages(new_status, last_message)
          @status = new_status if handler.handle(report[:rule_params], &block)
        end
        @all_messages << last_message if last_message
      end

      def up?
        status == :up
      end

      def warning?
        status == :warning
      end

      def down?
        status == :down
      end

      protected
        def equal_or_worse?(new_status)
          STATUS_MAP[@status] <= STATUS_MAP[new_status]
        end

        def append_report_messages(new_status, message)
          @report_messages = [] unless @status == new_status
          @report_messages << message if message
        end
    end
  end
end
