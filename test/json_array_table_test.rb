# coding: utf-8
require 'test_helper'
require 'json_array_table'

class JsonArrayTableTest < Minitest::Test

  def test_parse_generate
    text = <<-'EOB'
["c1", "c2", "c3", "c4"]
[1, "a", "", null]
[" ", "null", 12.34, "\\\t\r\n\"\\\t\r\n\""]
[1234, "全角テキスト", "", ""]
    EOB

    rows = JsonArrayTable.parse(text)

    expected = <<-'EOB'
[ "c1" , "c2"           , "c3"  , "c4"                   ]
[    1 , "a"            , ""    , null                   ]
[ " "  , "null"         , 12.34 , "\\\t\r\n\"\\\t\r\n\"" ]
[ 1234 , "全角テキスト" , ""    , ""                     ]
    EOB

    assert_equal(expected, JsonArrayTable.generate(rows))
  end

end
