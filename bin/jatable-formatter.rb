#!/usr/bin/env ruby

require "bundler/setup"
require "table_tools"

src = $stdin.read

begin
  df = TableTools.from_jatable(src, complement: nil)
  print df.to_jatable()
rescue => e
  puts src
  puts "----"
  puts e.message, e.class, e.backtrace
  puts "----"
end
