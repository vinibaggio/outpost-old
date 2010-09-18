module Scout
  module Consolidation
    def consolidate(status_list)
      status_list ||= []
      status_list.compact!

      return :unknown if status_list.empty?

      map = {
        :up => 2,
        :warning => 1,
        :unknown => 0,
        :down => -1,
      }
      remap = map.invert

      status = status_list.map { |st| map[st] }.min
      remap[status]
    end
  end
end
