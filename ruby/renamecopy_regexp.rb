# -*- coding: utf-8 -*-
#使い方
#d:\src\下の拡張子cppをccに変更する例.
#d:\src> ruby d:\src, rename_copy.rb, (.*).cpp$, \1.cc
#rename indir frompattern topattern


#正規表現に従って、ファイル名をリネームコピーするスクリプト.
#現時点では、実行したパスにコピーするので要注意

require 'fileutils'
require 'pathname'
 
$fromPattern
$toPattern
$baseDir
 
def main
 
    if ARGV.length != 3 then
        puts "rename.rb indir frompattern topattern"
		puts "example rename.rb d:\src, (.*).cpp$, \1.cc"
 		exit
 	end
 	
	$baseDir = ARGV[0]
	$fromPattern = /#{ARGV[1]}/
	$toPattern = ARGV[2]
	
	traverse($baseDir)

end

def rename(fromPath, toPath)

	if not File.exist?(toPath)
		FileUtils.copy(fromPath, toPath)
	else
		puts "duplicated!! failed copy." + toPath.to_s
	end

end

def traverse(nowdir)

    Dir.foreach(nowdir) do |aPath|
		fullPathObj = Pathname.new(nowdir) + aPath
		fullPath = fullPathObj.to_s
		
		if File.ftype(fullPath) != "directory"
			if aPath =~ $fromPattern then
				replaceStr = aPath.gsub($fromPattern,  $toPattern)
#				puts fullPath + "," + replaceStr
				rename(fullPath, replaceStr)
			end
		end
	end
end

main
