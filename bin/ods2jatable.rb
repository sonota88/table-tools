#!/usr/bin/env ruby

require "json"

require "bundler/setup"
require "roo"

file = ARGV.shift
sheet_name = ARGV.shift

ods = Roo::LibreOffice.new(file)
sheet = ods.sheet(sheet_name)

rn = 0 # row number
while rn < sheet.last_row
  rn +=1
  cols = sheet.row(rn)
  puts JSON.generate(cols)
end
