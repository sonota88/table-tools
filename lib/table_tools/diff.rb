require 'tempfile'

module TableTools
  class Diff

    def self.diff_check_num_cols(df_a, df_b)
      num_cols_exp = df_a.colnames.size
      num_cols_act = df_b.colnames.size

      if num_cols_exp != num_cols_act
        file_exp = Tempfile.open("expected")
        file_act = Tempfile.open("actual")

        df_a.colnames.each { |colname|
          file_exp.puts colname
        }
        df_b.colnames.each { |colname|
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

    def self.diff(df_a, df_b, opts={})
      diff_check_num_cols(df_a, df_b)

      maxlens_a = df_a.mrtable_calc_maxlens()
      maxlens_b = df_b.mrtable_calc_maxlens()

      maxlens = []
      (0...(maxlens_a.size)).each{|i|
        maxlens[i] = [maxlens_a[i], maxlens_b[i]].max
      }

      df_b2 =
        if df_a.rows.size == df_b.rows.size
          replace_any(df_b, df_a)
        else
          df_b
        end

      t_a = df_a.to_mrtable({ :maxlens => maxlens })
      t_b = df_b2.to_mrtable({ :maxlens => maxlens })

      tmp_act = Tempfile.open("actual")
      tmp_act.print t_b

      tmp_exp = Tempfile.open("expected")
      tmp_exp.print t_a

      tmp_act.close
      tmp_exp.close

      out = `diff -u "#{tmp_exp.path}" "#{tmp_act.path}"`

      tmp_act.close!
      tmp_exp.close!

      out
    end

    def self.mrtable_diff(src_a, src_b, opts={})
      df_a = TableTool.from_mrtable(src_a)
      df_b = TableTool.from_mrtable(src_b)

      Diff.diff(df_a, df_b)
    end

    C_RESET = "\e[0m"
    C_RED   = "\e[31m"
    C_GREEN = "\e[32m"
    C_BLUE  = "\e[34m"

    def self.print_color_diff(text)
      lines = text.split("\n", -1)
      lines.each{|line|
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
