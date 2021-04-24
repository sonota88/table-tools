# coding: utf-8
require "test_helper"
require "table_tools/spread_sheet"

class DataFrameTest < Minitest::Test

  def test_to_mrtable
    text = <<-'EOB'
[ "item"     , null , ">>begin" , "d1"   , null    , null                    ]
[ null       , null , null      , null   , null    , null                    ]
[ "a5"       , null , null      , null   , null    , null                    ]
[ ">>begin"  , null , "1"       , 2      , 3       , 4                       ]
[ null       , null , null      , null   , null    , null                    ]
[ null       , null , "id"      , "name" , "memo"  , "ctime"                 ]
[ null       , null , 1         , "aa"   , 543     , "2019-07-04 12:13:14:0" ]
[ null       , null , 2         , "ああ" , "fdsaf" , "2019-07-04 12:13:14:0" ]
[ "# メモ"   , null , null      , null   , null    , null                    ]
[ null       , null , 3         , "表"   , "fdsaf" , "2019-07-04 12:13:14:0" ]
[ ">>end"    , null , null      , null   , null    , null                    ]
    EOB

    rows_all = text.lines.map { |line| JSON.parse(line) }

    rows = TableTools::SpreadSheet.extract(rows_all)

    df = TableTools::DataFrame.new(
      rows[2],
      rows[3..-1]
    )

    actual = rows
             .map { |cols| JSON.generate(cols) + "\n" }
             .join("")

    expected = <<-'EOB'
[ "id" , "name" , "memo"  , "ctime"                 ]
[    1 , "aa"   ,     543 , "2019-07-04 12:13:14:0" ]
[    2 , "ああ" , "fdsaf" , "2019-07-04 12:13:14:0" ]
[    3 , "表"   , "fdsaf" , "2019-07-04 12:13:14:0" ]
[ null , null   , null    , null                    ]
    EOB

    assert_equal(expected, df.to_jatable())
  end

end
