# coding: utf-8

module TableTools

  class DataFrame
    attr_reader :colnames, :rows

    def initialize(colnames, rows)
      @rows = rows
      @colnames = colnames
    end
  end

end
