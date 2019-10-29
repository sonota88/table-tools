require "table_tools/version"
require 'table_tools/data_frame'

autoload :Mrtable, 'mrtable'

module TableTools

  def self.from_mrtable(src)
    colnames, rows = Mrtable.parse(src)
    DataFrame.new(colnames, rows)
  end

end
