require './Sentence.rb'
require './SentenceReader.rb'
require 'optparse'
require 'Pathname'

OPTION = {}

def init_opt_parser
  opt = OptionParser.new
  opt.on('-f VAL[VAL]') {|v| OPTION[:infile] = v}
  opt.on('-d VAL[VAL]') {|v| OPTION[:indir] = v}
end

def select_file(in_dir)
  entries = Dir::entries(File.expand_path(in_dir))
  entries.delete(".")
  entries.delete("..")
  (Pathname(in_dir) + entries.sample).to_s
end

def main

  opt_parser = init_opt_parser
  opt_parser.parse!(ARGV)

  infile = ""
  if OPTION.has_key?(:infile)
    infile = OPTION[infile]
  elsif OPTION.has_key?(:indir)
    infile = select_file(OPTION[:indir])
  end
  puts "infile:" + infile

  env = {}
  env[:infile] = infile
  env[:sentence_filename] = 'sentence'

  make_sentence_file(env)
end

def make_sentence_file(env)

  sentences = []
  sentence_reader = SentenceReader.new
  sentence_reader.read(env[:infile]) do |sentence|
    sentences << sentence
  end

  selected_sentence = sentences.sample(1)[0] 

  if selected_sentence.nil?
    puts "sentence is nil!!"
  end
  
  File.open(env[:sentence_filename], "w") do |f|
    lines = [
      selected_sentence.subscript,
      selected_sentence.sentence_escape_ch('(',')'),
      selected_sentence.sentence
    ]
    lines.each do |line|
      f.write(line.to_s + "\n")
    end
  end
end

main
