require 'outpost/scout'

class Outpost
  include Scout::Consolidation

  @@scouts = []
  @@reports = {}

  class << self
    def depends(dependencies, &block)
      dependencies.each do |scout, name|
        @@current_scout = scout
      end
      class_eval(&block)
      @@scouts << @@current_scout.new(@@options)
    end

    def report(status, rules)
      @@reports[@@current_scout] ||= {}
      @@reports[@@current_scout][rules.keys.first] = rules.values.inject({}) do |result, val|
        result[val] = status
        result
      end
    end

    def options(options={})
      @@options = options
    end

    def check!
      @@scouts.each { |scout| scout.measure! }
      consolidate(report_status)
    end

    private

    def report_status
      statuses = @@scouts.map do |scout|
        scout.build_report(@@reports[scout.class])
      end
    end
  end
end
