#指定フォルダ下（サブフォルダ含む）のファイルを探索して、名称（パターン）ごとに指定フォルダに移動する。
#コマンドライン引数は、探索対象のルートフォルダ.
require 'pathname'
require 'fileutils'


#移動元ファイルパターンと移動先フォルダを保持する連想配列.
$TARGET_FILES = nil

def main
	if ARGV.length != 1 then
		puts "コマンドライン引数異常!! 読込元フォルダを指定して下さい"
		exit
	end
	
	# 移動元ファイルパターンと移動先フォルダパスを設定する.
	$TARGET_FILES = {
		/Applet.*log/ => ".¥¥AppletLog",
		/csv$/ => ".¥¥CsvLog",
	}
	
	targetLogDir = ARGV[0]
    visitorDir(targetLogDir)
end

#このフォルダを探索して、$TARGET_FILESに設定された移動対象ファイルならフォルダ移動する.
#フォルダの場合は、下位フォルダを探索する.
def visitorDir(nowdir)

    # 移動先ディレクトリパス
	toDir = ""
	
    # ディレクトリ内のファイルを探索する.
	Dir.foreach(nowdir) do |aPath|
		targetDir = ""
        
        # フルパスを取得する.
		fullPathObj = Pathname.new(nowdir) + aPath
		fullPath = fullPathObj.to_s
	
		# 対象ファイルがディレクトリの場合
		if File.ftype(fullPath) == "directory" 
			if aPath != "." and aPath != ".."
				#下位ディレクトリを探索する.
				visitorDir(fullPath)
			end
		#ファイルの場合
		else
            # 移動対象かどうかチェックする.
			$TARGET_FILES.each_pair do |pattern, toDir|
				if aPath =‾ pattern
					#ファイル名がパターンに合致すれば移動対象とする.
					targetDir = toDir
                    break
				end
			end
		end
		
        # 移動先ディレクトリがあれば
		if targetDir != "" and targetDir != nil
            # 対象ファイルを移動する.
			puts fullPath + "," + targetDir
			moveFile(fullPath, targetDir)
		end
	end
end

def moveFile(fromFile, toDir)
	#フォルダを作る（再帰的）
	FileUtils.mkdir_p(toDir)
	#移動する.
	FileUtils.mv(fromFile, toDir)
end

# 処理実行する。
main