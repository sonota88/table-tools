# coding: utf-8
require "mrtable"

module Mrtable

  # monkey patch for v0.0.4
  # TODO opts を任意にする
  def self.generate(header_cols, rows, opts)
    table = Table.new(header_cols, rows)

    serialized = table.map_col_with_ci { |col, _|
      serialize_col(col)
    }

    maxlens = opts[:maxlens] || serialized.calc_maxlens()

    padded = serialized.map_col_with_ci { |col, ci|
      pad_col col, maxlens[ci]
    }

    lines = []
    lines << to_table_row(padded.header_cols)
    lines << to_table_row(maxlens.map { |len| "-" * len })
    lines += padded.rows.map { |cols|
      to_table_row(cols)
    }
    lines.map { |line| line + "\n" }.join("")
  end

  def self.calc_maxlens(header_cols, rows)
    table = Mrtable::Table.new(header_cols, rows)
    serialized = table.map_col_with_ci { |col, _|
      serialize_col(col)
    }
    serialized.calc_maxlens()
  end

end
