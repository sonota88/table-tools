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

end
