module TableTools
  module Parser
    module PostgresParser
      def self.parse(src)
        lines = src.split("\n")
        rows =
          lines
            .select{ |line| /^ / =~ line }
            .map{ |line|
              cols = line.split(" | ")
              cols
                .map{ |col| col.strip }
                .map{ |col| col == "NULL" ? nil : col }
            }
        rows
      end
    end
  end
end

if __FILE__ == $0
  require "pp"

  src = <<-EOB
 id | name
----+-------
 1  | foo
 2  | NULL
  EOB
  rows = TableTool::Parser::PostgresParser.parse(src)
  pp rows
end
