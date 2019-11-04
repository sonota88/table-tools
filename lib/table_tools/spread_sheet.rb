# coding: utf-8

module TableTools
  class SpreadSheet

    BEGIN_MARKER = '>>begin'

    def self.extract(rows)
      first_rn = find_first_rn(rows)
      first_cn = find_first_cn(rows)

      rows2 = filter_rows(rows, first_rn)
      rows3 = filter_cols(rows2, first_cn)

      rows3
    end

    def self.find_first_rn(rows)
      rn = 0
      rows.each { |cols|
        rn += 1
        return rn if cols[0] == BEGIN_MARKER
      }

      raise "begin marker not found"
    end

    def self.find_first_cn(rows)
      cols = rows[0]

      cn = 0
      cols.each { |col|
        cn += 1
        return cn if col == BEGIN_MARKER
      }

      raise "begin marker not found"
    end

    def self.filter_rows(rows, first_rn)
      new_rows = []
      rn = 0
      rows.each { |cols|
        rn += 1
        if rn >= first_rn
          new_rows << cols
        end
      }
      new_rows
    end

    def self.filter_cols(rows, first_cn)
      rows.map { |cols|
        new_cols = []
        cn = 0
        cols.each { |col|
          cn += 1
          if cn >= first_cn
            new_cols << col
          end
        }
        new_cols
      }
    end
  end
end


if $0 == __FILE__
  require 'json'
  require 'pp'

  require 'table_tools'

  text = <<-'EOB'
[ "item"     , null , ">>begin" , "d1"   , null    , null                    ]
[ null       , null , null      , null   , null    , null                    ]
[ "a5"       , null , null      , null   , null    , null                    ]
[ ">>begin"  , null , 1         , 2      , 3       , 4                       ]
[ null       , null , null      , null   , null    , null                    ]
[ null       , null , "id"      , "name" , "memo"  , "ctime"                 ]
[ null       , null , 1         , "aa"   , 543     , "2019-07-04 12:13:14:0" ]
[ null       , null , 2         , "ああ" , "fdsaf" , "2019-07-04 12:13:14:0" ]
[ "# メモ"   , null , null      , null   , null    , null                    ]
[ null       , null , 3         , "表"   , "fdsaf" , "2019-07-04 12:13:14:0" ]
[ ">>end"    , null , null      , null   , null    , null                    ]
  EOB

  rows_all = []
  text.each_line{|line| rows_all << JSON.parse(line) }

  rows = TableTools::SpreadSheet.extract(rows_all)
  pp rows

  df = TableTools::DataFrame.new(
    rows[2],
    rows[3..-1]
  )

  puts df.to_mrtable()
end
