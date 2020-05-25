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

    def to_jatable(opts = {})
      df2 = self

      if opts.has_key?(:null_str)
        df2 = map_col_with_ci{|col, ci|
          col.nil? ? opts[:null_str] : col
        }
      end

      JsonArrayTable.generate(
        [df2.colnames] + df2.rows,
        opts
      )
    end

    def to_json_array_table(opts = {})
      to_jatable(opts)
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

    def select_cols
      selected_cis = []
      @colnames.each_with_index do |colname, ci|
        values = rows.map { |cols| cols[ci] }
        if yield(colname, values)
          selected_cis << ci
        end
      end

      new_colnames =
        selected_cis.map { |ci| @colnames[ci] }

      new_rows = Array.new(@rows.size) { |i| [] }
      selected_cis.each do |ci|
        @rows.each_with_index { |cols, ri|
          new_rows[ri] << cols[ci]
        }
      end

      DataFrame.new(new_colnames, new_rows)
    end

  end

end
