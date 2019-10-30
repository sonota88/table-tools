# coding: utf-8

module TableTools

  class DataFrame
    attr_reader :colnames, :rows

    def initialize(colnames, rows)
      @rows = rows
      @colnames = colnames
    end

    def to_mrtable
      Mrtable.generate(
        @colnames,
        @rows
      )
    end

    def to_jatable
      JsonArrayTable.generate(
        [@colnames] + @rows
      )
    end

    # ci: column index
    # @return new data frame
    def map_col_with_ci
      new_rows = @rows.map do |cols|
        new_cols = []
        cols.each_with_index { |col, ci|
          new_cols << yield(col, ci)
        }
        new_cols
      end

      new_colnames = []
      @colnames.each_with_index { |col, ci|
        new_colnames << yield(col, ci)
      }

      DataFrame.new(new_colnames, new_rows)
    end

  end

end
