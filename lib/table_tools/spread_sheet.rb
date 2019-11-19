# coding: utf-8

module TableTools
  class SpreadSheet

    BEGIN_MARKER = '>>begin'

    def self.extract(rows)
      first_rn = find_first_rn(rows)
      first_cn = find_first_cn(rows)

      rows2 =
        filter_rows(rows, first_rn)
        .select { |cols| /^#/ !~ cols[0] }

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
