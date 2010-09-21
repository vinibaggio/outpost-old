module Scout
  module Consolidation

    # The status list and their priority is as follows
    # (from lowest to highest priority):
    # 
    #     :up
    #     :warning
    #     :unknown
    #     :down    
    #    
    PRIORITY = {
      :up => 2,
      :warning => 1,
      :unknown => 0,
      :down => -1
    }

    # Return the consolidate in the priority list priority
    #
    # consolidate [:up] # => [:up]
    # consolidate [:up, :down] # => [:down]
    # consolidate [nil] # => [:unknown]
    #
    def consolidate(status_list)
      status_list ||= []
      status_list.compact!
      
      return :unknown if status_list.empty?
      
      status = collect_min_priority(:status_list => status_list)
      PRIORITY.invert[status]
    end
    
    # Collect the minimum priority in the status list
    #
    # collect_min_priority :status_list => [:up] # => 2
    # collect_min_priority :status_list => [:up, :down] # => -1
    #
    def collect_min_priority(options)
      status_list = options[:status_list]
      status_list.collect { |status| PRIORITY[status] }.min
    end

  end
end
