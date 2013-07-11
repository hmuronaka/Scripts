class Sentence
  attr_accessor :sentence, :subscript
  
  def initialize(sentence, subscript = "")
    @sentence = sentence
    @subscript = subscript
  end

  # @に続く単語を空白にして出力する
  def sentence_escape(&b)
    escaped_line = @sentence
    # 単語の先頭の@を検索対象とする.
    pattern = "(?:^|[^@])@([^@][^\s]*)"
    while escaped_line =~ /#{pattern}/ do
      word = b.call($1)
      escaped_line = escaped_line.sub(/#{pattern}/, " " + word)
    end
    escaped_line
  end
  
  def sentence_escape_ch(begin_ch, end_ch)
    sentence_escape do |word|
      ret_word = ""
      ret_word << begin_ch
      word.length.times { ret_word << " " }
      ret_word << end_ch
    end
  end

  def to_s
    lines = [
      @sentence,
      sentence_escape_ch('(',')'),
      @subscript
    ].join(',')
  end
end
