#!/usr/bin/env ruby

require "bundler/setup"
require "table_tools"

src = $stdin.read

begin
  df = TableTools.from_mrtable(src, complement: nil)
  print df.to_mrtable()
rescue => e
  puts src
  puts "----"
  puts e.message, e.class, e.backtrace
  puts "----"
end
