require "test_helper"

class TableToolsTest < Minitest::Test

  def test_from_mrtable
    mrtable_src = <<-EOB
| a   | b   |
| --- | --- |
| 1   |     |
    EOB

    df = TableTools.from_mrtable(mrtable_src)

    pp df

    assert_equal("a", df.colnames[0])
    assert_equal("b", df.colnames[1])

    assert_equal("1", df.rows[0][0])
    assert_equal(nil, df.rows[0][1])
  end

  def test_from_jatable
    jatable_src = <<-EOB
[ "c1", "c2"  ]
[ "1", null ]
    EOB

    df = TableTools.from_jatable(jatable_src)
    # pp df

    assert_equal("c1", df.colnames[0])
    assert_equal("c2", df.colnames[1])

    assert_equal("1", df.rows[0][0])
    assert_equal(nil, df.rows[0][1])
  end

end
