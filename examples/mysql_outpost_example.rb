require 'outpost'

require 'mysql_scout'


class MysqlOutpostExample < Outpost

  depends :mysql => "database 01" do
    report :up, :response_code => {:equal => 200}
  end
end
