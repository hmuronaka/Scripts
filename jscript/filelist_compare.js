
var shell;
var fileSystem;
var FORREADING      = 1;    // 読み取り専用 

// DateのtoLocaleDateStringを独自書式に変更.
Date.prototype.toLocaleDateString = function()
{
    return [
        this.getFullYear(),
        this.getMonth() + 1,
        this.getDate()
        ].join( '/' );
}

// DateのtoLocaleStringを独自書式に変更.
Date.prototype.toLocaleString = function()
{
    return [
        this.getFullYear(),
        this.getMonth() + 1,
        this.getDate()
        ].join( '/' ) + " " + this.toLocaleTimeString();
}

Array.prototype.unique = function() {
  var o = {}
    , i
    , l = this.length
    , r = [];
    
  for (i = 0; i < l; i += 1) o[this[i]] = this[i];
  for (i in o) r.push(o[i]);
  
  return r;
}


// filelist.jsの結果を1オブジェクトで表現する.

function FileInfo(path,filename,filesize,datetime) {
	this.path = path;
	this.filename = filename;
	this.filesize = filesize;
	this.datetime = datetime;
}

FileInfo.prototype.getFullPath = function()  {
	return this.path.toLowerCase() + this.filename.toLowerCase();
}

// path + filenameを辞書的に比較する
// 負数 このオブジェクトの方が小さい
// 0 等しい
// 正数 このオブジェクトが大きい
FileInfo.prototype.compareFilePath = function(otherPath) {
	
	var fullPath = this.getFullPath();
	
	if( fullPath < otherPath ) {
		return -1;
	} else if( fullPath > otherPath ) {
		return 1;
	}
	return 0;
}

FileInfo.prototype.toString = function(delimiter) {
	return [this.path, this.filename, this.filesize, this.datetime.toLocaleString()].join(delimiter);
}

function FileList(filePath, baseDir) {
	this.filePath = filePath;
	this.baseDir = baseDir;
	this.fileInfos = [];
}

FileList.prototype.readFile = function(fileSystem) {
	
	// ファイルを読む.
	var textStream = fileSystem.OpenTextFile(this.filePath, FORREADING, false);
	var allText = new Array();
	// 全行取得
	while( !textStream.AtEndOfStream ) {
		var line = textStream.ReadLine();
		allText.push(line);
	}
	textStream.Close();
	
	var regexp = new RegExp("\"(.*)\"\\s*,\\s*\"(.*)\"\\s*,\\s*(\\d+)\\s*,\\s*(\\d*)/(\\d+)/(\\d+)\\s*(\\d+):(\\d+):(\\d+)");
	
	for(var i = 0; i < allText.length; i++) {
	
		var result = allText[i].match(regexp);
		if( result == null || result.length != 10 ) {
			continue;
		}
		
		var pos = 0
		var path = result[++pos];
		var filename = result[++pos];
		var filesize = parseInt(result[++pos], 10);
		var date = new Date( parseInt(result[++pos],10), 
			parseInt(result[++pos],10) - 1,
			parseInt(result[++pos],10),
			parseInt(result[++pos],10),
			parseInt(result[++pos],10),
			parseInt(result[++pos],10));
			
		
		this.fileInfos.push( new FileInfo(
			path,
			filename,
			filesize,
			date));

	}
}

FileList.prototype.getFilePathes = function() {
	var result = [];
	for(var i = 0; i < this.fileInfos.length; i++) {
		result.push( this.fileInfos[i].getFullPath() );
	}
	return result;
}

FileList.prototype.findFileInfo = function(filePath) {
	var result = null;
	for(var i = 0; i < this.fileInfos.length; i++) {
		if( this.fileInfos[i].compareFilePath(filePath) == 0 ) {
			result = this.fileInfos[i];
			break;
		}
	}
	return result;
}

function main() {
	
	shell = WScript.CreateObject("WScript.Shell");
	fileSystem = WScript.CreateObject("Scripting.FileSystemObject");
	
	var filePath1 = WScript.Arguments(0);
	var filePath2 = WScript.Arguments(1);
	var baseDir1 = "";
	var baseDir2 = "";
	

	var fileList1 = new FileList(filePath1, baseDir1);
	var fileList2 = new FileList(filePath2, baseDir2);
	
	fileList1.readFile(fileSystem);
	fileList2.readFile(fileSystem);
	
	var result = compareFileList( fileList1, fileList2 );
	
	output(result);
	
}

function compareFileList(fileList1, fileList2) {

	var result = [];

	var filePathes1 = fileList1.getFilePathes();
	var filePathes2 = fileList2.getFilePathes();
	var mergedPath = filePathes1.concat(filePathes2).unique().sort();
	
	for(var i = 0; i < mergedPath.length; i++) {
		
		var fileInfo1 = fileList1.findFileInfo( mergedPath[i] );
		var fileInfo2 = fileList2.findFileInfo( mergedPath[i] );
		
		// 両方の状態が見つかったとき.
		var line = "";
		if( fileInfo1 != null ) {
			line = fileInfo1.toString(",");
		} else {
			line += ",,,";
		}
		line += ",";
		
		if( fileInfo2 != null ) {
			line += fileInfo2.toString(",");
		} else {
			line += ",,,";
		}
		line += ",";
		
		if( fileInfo1 != null && fileInfo2 != null ) {
			line += getCompareStr(fileInfo1.filesize, fileInfo2.filesize);
			line += ",";
			
			var date1 = fileInfo1.datetime.getTime();
			var date2 = fileInfo2.datetime.getTime();
			line += getCompareStr(date1, date2);
		}
		result.push(line);
	}
	
	return result;
}

function getCompareStr(value1, value2) {
	var result = "";
	if( value1 > value2 ) {
		result = ">";
	} else if( value1 < value2 ) {
		result = "<";
	} else {
		result = "=";
	}
	return result;
}


function output(lines) {
	for(var i = 0; i < lines.length; i++) {
		WScript.echo(lines[i]);
	}
}

main();