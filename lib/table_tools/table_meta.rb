module TableTools
  class TableMeta
    def initialize(df)
      @df = df
      @map = @df.rows.to_h
    end

    def self.from_array_table(atab)
      df = TableTools.from_jatable(atab)
      TableMeta.new(df)
    end

    def [](name)
      @map[name]
    end
  end
end

if $0 == __FILE__
  $LOAD_PATH.unshift "../"
  require "table_tools"

  tm = TableTools::TableMeta.from_array_table(<<~ATAB)
    [ "name" , "type"   ]
    [ "id"   , "int"    ]
    [ "name" , "string" ]
  ATAB

  p tm["id"]
  p tm["name"]
end
