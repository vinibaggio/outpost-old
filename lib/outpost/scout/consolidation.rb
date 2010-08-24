module Scout::Consolidation
  def consolidate(status_list)
    status_list ||= []

    map = {
      :up => 2,
      :warning => 1,
      :down => 0,
    }
    remap = map.invert.update(nil => :unknown)

    status = status_list.compact.map { |st| map[st] }.min
    remap[status]
  end
end
