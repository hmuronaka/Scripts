require './Sentence.rb'

class SentenceReader

  def read(file_path, &b)
    File.open(file_path, "r") do |file|
      sentence = nil
      file.each_line do |line|
        line.chomp!
        next if line.empty?

        if line =~ /^#/
          # this is comment line.
        elsif line =~ /^[\d\w@"']/
          #this is english sentence.
          if sentence != nil
            b.call(sentence)
            sentence = nil
          end
          sentence = Sentence.new(line)
        else
          if sentence == nil
            # this is ignore.
          else
            sentence.subscript = line
          end
        end
      end
      if sentence != nil
        b.call(sentence)
      end
    end
  end
end
