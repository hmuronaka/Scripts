# �w��t�H���_���̃t�@�C���̃^�C���X�^���v�ꗗ(CSV)��������������.
require 'pathname'
require 'kconv'

#�t�@�C���p�X���擾����.
$baseDir = ARGV[0]
$excludeExtensionPattern
$excludeFilePattern

def main
	
	excludeExtension = ENV['EXCLUDE_EXTENSION'].toutf8
	excludeFile = ENV['EXCLUDE_FILE'].toutf8
	
	$excludeExtensionPattern =  /#{excludeExtension}/
	$excludeFilePattern = /#{excludeFile}/
	
	parse($baseDir)
	
end

def parse(nowDir)

	nowDir = nowDir.gsub("/", "\\")
	dirList = Array.new

	Dir.foreach(nowDir) do |aPath|
		if aPath != "." && aPath != ".." then
			fullPath = (Pathname.new(nowDir) + aPath).to_s
			ftype = File.ftype(fullPath)
			if ftype == "file" then
				if not aPath.toutf8 =~ $excludeExtensionPattern  and
				   not aPath.toutf8 =~ $excludeFilePattern then
				   printFile( nowDir, aPath, fullPath )
				end
			else ftype == "directory"
				dirList.push(aPath)
			end
		end
	end
	
	dirList.each() do |aDir|
		fullPath = (Pathname.new(nowDir) + aDir).to_s
		parse(fullPath)
	end
end


def printFile(nowDir, aFilename, fullPath)
	#�o��.
	updateTime = File.mtime(fullPath)
	updateTimeStr = updateTime.strftime("%Y/%m/%d %H:%M:%S")
	puts nowDir + "," + aFilename + "," + File.size(fullPath).to_s + ", " +  updateTimeStr
end

main