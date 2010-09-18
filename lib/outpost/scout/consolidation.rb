module Scout
  module Consolidation
    def consolidate(status_list)
      status_list ||= []

      status_list = convert_nils_to_unknown(status_list)
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

    def convert_nils_to_unknown(list=[])
      if list.empty?
        [ :unknown ]
      else
        list.map { |e| e.nil? ? :unknown : e }
      end
    end
  end
end
