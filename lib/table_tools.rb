require "table_tools/version"
require 'table_tools/data_frame'
require 'mrtable_custom'
require 'json_array_table'

module TableTools

  def self.from_mrtable(src)
    colnames, rows = Mrtable.parse(src)
    DataFrame.new(colnames, rows)
  end

  def self.from_jatable(src)
    colnames, rows = JsonArrayTable.parse(src)
    DataFrame.new(colnames, rows)
  end

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
      TableTool.print_color_diff(out)

      raise "different column size: a(#{num_cols_a}) b(#{num_cols_b})"
    end
  end

  def self.diff(df_a, df_b, opts={})
    diff_check_num_cols(df_a, df_b)

    maxlens_a = df_a.mrtable_calc_maxlens()
    maxlens_b = df_b.mrtable_calc_maxlens()

    maxlens = []
    (0...(maxlens_a.size)).each{|i|
      maxlens[i] = [maxlens_a[i], maxlens_b[i]].max
    }

    t_a = df_a.to_mrtable({ :maxlens => maxlens })
    t_b = df_b.to_mrtable({ :maxlens => maxlens })

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

    TableTool.diff(df_a, df_b)
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
