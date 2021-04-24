require "tempfile"

module TableTools
  class Diff

    def self.diff_check_num_cols(df_exp, df_act)
      num_cols_exp = df_exp.colnames.size
      num_cols_act = df_act.colnames.size

      if num_cols_exp != num_cols_act
        file_exp = Tempfile.open("expected")
        file_act = Tempfile.open("actual")

        df_exp.colnames.each { |colname|
          file_exp.puts colname
        }
        df_act.colnames.each { |colname|
          file_act.puts colname
        }

        file_act.close
        file_exp.close

        out = `diff -u "#{file_exp.path}" "#{file_act.path}"`

        file_act.close!
        file_exp.close!

        Diff.print_color_diff(out)

        raise "different column size: expected(#{num_cols_exp}) actual(#{num_cols_act})"
      end
    end

    def self.replace_any(df_act, df_exp)
      new_rows = []

      df_exp.rows.each_with_index { |cols, ri|
        cols.each_with_index { |col, ci|
          new_rows[ri] ||= []
          new_rows[ri][ci] =
            if col == "(ANY)"
              "(ANY)"
            else
              df_act.rows[ri][ci]
            end
        }
      }

      DataFrame.new(
        df_act.colnames,
        new_rows
      )
    end

    def self.diff(df_exp, df_act, opts={})
      diff_check_num_cols(df_exp, df_act)

      maxlens_exp = df_exp.mrtable_calc_maxlens()
      maxlens_act = df_act.mrtable_calc_maxlens()

      maxlens = []
      (0...(maxlens_exp.size)).each { |i|
        maxlens[i] = [maxlens_exp[i], maxlens_act[i]].max
      }

      df_act2 =
        if df_exp.rows.size == df_act.rows.size
          replace_any(df_act, df_exp)
        else
          df_act
        end

      mrt_exp = df_exp.to_mrtable({ :maxlens => maxlens })
      mrt_act = df_act2.to_mrtable({ :maxlens => maxlens })

      tmp_act = Tempfile.open("actual")
      tmp_act.print mrt_act

      tmp_exp = Tempfile.open("expected")
      tmp_exp.print mrt_exp

      tmp_act.close
      tmp_exp.close

      out = `diff -u "#{tmp_exp.path}" "#{tmp_act.path}"`

      tmp_act.close!
      tmp_exp.close!

      out
    end

    def self.mrtable_diff(mrt_exp, mrt_act, opts={})
      df_exp = TableTool.from_mrtable(mrt_exp)
      df_act = TableTool.from_mrtable(mrt_act)

      Diff.diff(df_exp, df_act)
    end

    C_RESET = "\e[0m"
    C_RED   = "\e[31m"
    C_GREEN = "\e[32m"
    C_BLUE  = "\e[34m"

    def self.print_color_diff(text)
      lines = text.split("\n", -1)
      lines.each { |line|
        color = case line
                when /^@@/ ; C_BLUE
                when /^\-/ ; C_RED
                when /^\+/ ; C_GREEN
                else       ; nil
                end

        if color
          puts color + line + C_RESET
        else
          puts line
        end
      }
    end

  end
end
