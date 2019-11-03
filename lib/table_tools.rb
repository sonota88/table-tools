# coding: utf-8
require "table_tools/version"
require 'table_tools/data_frame'
require 'table_tools/diff'
require 'table_tools/mrtable_custom'
require 'table_tools/json_array_table'

module TableTools

  def self.from_mrtable(src, opts={})
    colnames, rows = Mrtable.parse(src, opts)
    DataFrame.new(colnames, rows)
  end

  # rows がない場合、空配列になること
  def self.from_jatable(src, opts={})
    colnames, *rows = JsonArrayTable.parse(src, opts)
    DataFrame.new(colnames, rows)
  end

  def self.from_json_array_table(src, opts={})
    TableTools.from_jatable(src, opts)
  end

  def self.diff(df_a, df_b, opts={})
    TableTools::Diff.diff(df_a, df_b, opts={})
  end

  def self.mrtable_diff(src_a, src_b, opts={})
    TableTools::Diff.mrtable_diff(src_a, src_b, opts={})
  end

  def self.print_color_diff(text)
    TableTools::Diff.print_color_diff(text)
  end
end
