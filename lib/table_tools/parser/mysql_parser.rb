module TableTools
  module Parser
    module MysqlParser
      def self.parse(src)
        # $stderr.puts [123456, src]
        lines = src.split("\n")
        rows =
          lines
            .select{ |line| /^\+\-/ !~ line }
            .map{ |line|
              cols = " #{line} ".split(" | ")
              cols
                .map{ |col| col.strip }[1..-1]
                .map{ |col| col == "NULL" ? nil : col }
            }
        head = rows[0]
        [head] + rows[1..-1]
      end
    end
  end
end

if __FILE__ == $0
  require "pp"

  src = <<-EOB
+-------+--------+
| col1  | col2   |
+-------+--------+
| 1     | 22     |
| 12.34 | NULL   |
|       | null   |
+-------+--------+
  EOB
  rows = TableTool::Parser::MysqlParser.parse(src)
  pp rows
end
