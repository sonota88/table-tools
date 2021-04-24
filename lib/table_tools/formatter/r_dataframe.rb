module TableTools
  module Formatter
    class RDataframe
      def self.format(colnames, rows)
        s = "data.frame("

        colnames.each_with_index { |cn, i|
          head = (i == 0) ? "  " : "  ,"

          values = rows.map { |cols|
            cols[i]
          }.map { |col|
            col.nil? ? "NA" : '"' + col + '"'
          }.join(", ")

          s += "\n#{head}#{cn} = as.numeric(c(#{values}))"
        }

        s += "\n)"
        s + "\n"
      end
    end
  end
end
