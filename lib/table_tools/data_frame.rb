# coding: utf-8

module TableTools

  class DataFrame
    attr_reader :colnames, :rows

    def initialize(colnames, rows)
      @rows = rows
      @colnames = colnames
    end

    def to_mrtable(opts = {})
      df2 = self

      if opts.has_key?(:null_str)
        df2 = map_col_with_ci{|col, ci|
          col.nil? ? opts[:null_str] : col
        }
      end

      Mrtable.generate(df2.colnames, df2.rows, opts)
    end

    def to_jatable
      JsonArrayTable.generate(
        [@colnames] + @rows
      )
    end

    def to_json_array_table
      to_jatable
    end

    def rm_colname_prefix!
      @colnames = @colnames.map{|cn|
        if /^(.+?)\.(.+)$/ =~ cn
          $2
        else
          cn
        end
      }
    end

    def mrtable_calc_maxlens
      if @rows.empty?
        @colnames.map{|it| it.size }
      else
        Mrtable.calc_maxlens(@colnames, @rows)
      end
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
