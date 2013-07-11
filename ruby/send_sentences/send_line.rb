#!/usr/bin/ruby
send_file = 'sentence'
temp_file = send_file + ".temp"
read_dir = "~/english_grammer_basic/"
read_file = read_dir + "unit1.txt"
#mail_address = "YFA67198@nifty.com"
mail_address = "caprice29@i.softbank.jp"
mail_title = "english_grammer"

#sentenceファイルがなければ、sentenceファイルを作成する.
if !File.exists?(send_file)
  puts "create #{send_file} file."
  `ruby ./Main.rb -d #{read_dir}`
end

if !File.exists?(send_file)
  puts "'error 'create #{send_file} file."
  exit
end

puts 'send mail.'

#先頭行をメールで送信して、先頭行を削除する。
`sed -n 1p sentence | mail -s #{mail_title} #{mail_address}`
puts `sed -n 1p #{send_file}`
`sed 1d #{send_file} > #{temp_file}`
`mv #{temp_file} #{send_file}`

line = `sed -n 1p #{send_file}`
if line.empty?
  `rm #{send_file}`
end
