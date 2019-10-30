# coding: utf-8
require 'test_helper'
require 'table_tools/data_frame'

class DataFrameTest < Minitest::Test

  def test_to_mrtable
    df = TableTools::DataFrame.new(
      ["c1", "c2"],
      [
        ["1", nil]
      ]
    )

    expected = <<-EOB
| c1  | c2  |
| --- | --- |
|   1 |     |
    EOB

    assert_equal(expected, df.to_mrtable)
  end

  def test_to_jatable
    df = TableTools::DataFrame.new(
      ["c1", "c2"],
      [
        ["1", nil]
      ]
    )

    expected = <<-EOB
["c1","c2"]
["1",null]
    EOB

    assert_equal(expected, df.to_jatable)
  end

  # colnames は対象にしない方がよい？
  def test_map_col_with_ci
    df = TableTools::DataFrame.new(
      ["c1", "c2"],
      [
        ["a", "b"]
      ]
    )

    new_df = df.map_col_with_ci{|col, ci|
      "#{col}:#{ci}"
    }

    expected = <<-EOB
| c1:0 | c2:1 |
| ---- | ---- |
| a:0  | b:1  |
    EOB
    assert_equal(expected, new_df.to_mrtable)
  end

end
