# coding: utf-8
require 'test_helper'
require 'table_tools/diff'

class DiffTest < Minitest::Test

  def test_diff_replace_any_ok
    df_exp = TableTools::DataFrame.new(
      ["c1", "c2", "c3"],
      [
        ["1", "a", "(ANY)"]
      ]
    )

    df_act = TableTools::DataFrame.new(
      ["c1", "c2", "c3"],
      [
        ["1", "a", nil]
      ]
    )

    text = TableTools::Diff.diff(
      df_exp,
      df_act
    )

    expected = ""

    assert_equal(expected, text)
  end

  def test_diff_replace_any_ng
    df_exp = TableTools::DataFrame.new(
      ["c1", "c2", "c3"],
      [
        ["1", "a", "(ANY)"],
        ["2", "a", "(ANY)"]
      ]
    )

    df_act = TableTools::DataFrame.new(
      ["c1", "c2", "c3"],
      [
        ["1", "a", nil],
        ["2", "b", nil]
      ]
    )

    text = TableTools::Diff.diff(
      df_exp,
      df_act
    )

    text2 = text.split("\n")[3..-1].join("\n")

    expected = (<<-EOB).chomp
 | c1  | c2  | c3    |
 | --- | --- | ----- |
 |   1 | a   | (ANY) |
-|   2 | a   | (ANY) |
+|   2 | b   | (ANY) |
    EOB

    assert_equal(expected, text2)
  end

end
