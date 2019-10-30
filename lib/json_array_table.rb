# coding: utf-8
require 'json'

class JsonArrayTable

  def self.parse(text)
    text.lines.map{ |line| JSON.parse(line) }
  end

  def self.generate(rows, opts={})
    num_cols = rows[0].size

    serialized =
      map_col_with_ci(rows) do |col, _|
        col.to_json
      end

    max_lens =
      (0...num_cols).map do |ci|
        col_len_max(serialized, ci)
      end

    padded =
      map_col_with_ci(serialized) do |col, ci|
        pad_col(col, max_lens[ci])
      end

    lines =
      padded.map do |cols|
        "[ " + cols.join(" , ") + " ]\n"
      end

    lines.join("")
  end

  # private

  def self.map_col_with_ci(rows)
    rows.map do |cols|
      indexes = (0...cols.size).to_a
      cols.zip(indexes).map do |col_ci|
        yield *col_ci
      end
    end
  end

  def self.col_len_max(rows, ci)
    rows
      .map{ |cols| col_len(cols[ci]) }
      .max
  end

  # 32-126(0x20-0x7E), 65377-65439(0xFF61-0xFF9F)
  def self.hankaku?(c)
    /^[ -~｡-ﾟ]$/.match?(c)
  end

  def self.col_len(col)
    col.chars
      .map{ |ci| hankaku?(col[ci]) ? 1 : 2 }
      .sum
  end

  def self.pad_right(s, n)
    rest = n - col_len(s)
    return s if rest == 0
    s + (" " * rest)
  end

  def self.pad_left(s, n)
    rest = n - col_len(s)
    return s if rest == 0
    (" " * rest) + s
  end

  def self.int?(s)
    /^\-?[\d]+$/.match?(s)
  end

  def self.pad_col(col, maxlen)
    if int?(col)
      pad_left(col, maxlen)
    else
      pad_right(col, maxlen)
    end
  end

end
