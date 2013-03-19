//タイムスタンプ一覧(CSV)を自動生成する.

// ベースファイルパス
var baseDir;
// 対象外とする拡張子のパターン
var excludeExtensionPattern;
// 対象外とするファイル名のパターン
var excludeFilePattern;

var shell;
var fileSystem;


function main() {
	
	shell = WScript.CreateObject("WScript.Shell");
	fileSystem = WScript.CreateObject("Scripting.FileSystemObject");
	
	baseDir = WScript.Arguments(0);

	excludeExtensionPattern = new  RegExp(shell.ExpandEnvironmentStrings("%EXCLUDE_EXTENSION%"));
	excludeFilePattern = new  RegExp(shell.ExpandEnvironmentStrings("%EXCLUDE_FILE%"));

	parse(baseDir);
}

function parse(nowDir) {
	
	var dir = fileSystem.GetFolder(nowDir);
	var files = new Enumerator(dir.files);
	for(; !files.atEnd(); files.moveNext()) {
		var file = files.item();
		if( file.name.search(excludeExtensionPattern) == -1 && 
			file.name.search(excludeFilePattern) == -1 ) {
			printFile( nowDir, file, file.path );
		}
	}
	
	var dirList = dir.subFolders;
	var dirs = new Enumerator(dir.subFolders)
	
	for(; !dirs.atEnd(); dirs.moveNext()) {
		parse(nowDir + "\\" + dirs.item().name);
	}
	
}

function printFile(nowDir, aFile, fullPath) {

	var updateTime = new Date(aFile.DateLastModified);
	var updateTimeStr = updateTime.toLocaleDateString() + " " +  updateTime.toLocaleTimeString();
	WScript.echo(nowDir + "," + aFile.name + "," + aFile.Size + "," +  updateTimeStr);
}

main();