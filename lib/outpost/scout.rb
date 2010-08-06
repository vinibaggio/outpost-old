require 'outpost/scout/hooks/response_time'
require 'outpost/scout/hooks/response_code'

module Scout

  class Base
    def before_measurement
      puts "Base before measurement"
    end

    def measure!
      before_measurement
      response = execute
      after_measurement(response)

      build_report(response, {})
    end

    def after_measurement(response)
      puts "response: #{response}"
    end

    def build_report(response, rules)
      puts "response: #{response}, rules: #{rules}"
    end
  end
end
