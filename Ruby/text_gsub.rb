#!/usr/bin/env ruby
#
# Substitue text globally
#
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: text_gsub.rb text_file dict_file"
end.parse!

text_file = ARGV.shift
dict_file = ARGV.shift

dict = {}
File.read(dict_file).split(/\r|\r\n|\n/).each do |line|
  col = line.chomp.split("\t")
  dict[col[0]] = col[1]
end

File.open(text_file + '.gsub', 'w').puts File.read(text_file).gsub(
  Regexp.new(dict.keys.join('|')), dict
)
