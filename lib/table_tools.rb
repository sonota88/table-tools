require "table_tools/version"
require 'table_tools/data_frame'
require 'mrtable_custom'
require 'json_array_table'

module TableTools

  def self.from_mrtable(src)
    colnames, rows = Mrtable.parse(src)
    DataFrame.new(colnames, rows)
  end

  def self.from_jatable(src)
    colnames, rows = JsonArrayTable.parse(src)
    DataFrame.new(colnames, rows)
  end

end
