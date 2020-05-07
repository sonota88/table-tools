require 'tempfile'

module TableTools
  class Diff

    # TODO Use tempfile
    def self.diff_check_num_cols(df_a, df_b)
      num_cols_a = df_a.colnames.size
      num_cols_b = df_b.colnames.size

      if num_cols_a != num_cols_b
        ts = Time.now.to_i
        file_a = "/tmp/table_tool_diff_a_#{ts}.txt"
        file_b = "/tmp/table_tool_diff_b_#{ts}.txt"
        open(file_a, "w"){|f|
          df_a.colnames.each{|colname| f.puts colname }
        }
        open(file_b, "w"){|f|
          df_b.colnames.each{|colname| f.puts colname }
        }
        out = `diff -u "#{file_a}" "#{file_b}"`
        Diff.print_color_diff(out)

        raise "different column size: a(#{num_cols_a}) b(#{num_cols_b})"
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
