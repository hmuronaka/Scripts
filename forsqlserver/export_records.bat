SET DBUSER=%1
SET DBPASSWORD=%2
SET DB=%3

REM 指定したＤＢ上の全テーブルをTSV形式でエクスポートする.
REM 生成する実行バッチ名
SET OUTFILE=export_records_temp.bat

REM パッチ自動生成
echo FOR %%%%T IN ( > %OUTFILE%
bcp "SELECT name FROM Sys.Tables" queryout "tablenames.csv" -U %DBUSER% -P  %DBPASSWD% -d %DB% -c
type "tablenames.csv" >> %OUTFILE%
echo ) DO ( bcp %%%%T out "%%%%T.tsv" -U %DBUSER% -P %DBPASSWD% -d %DB% -c ) >>  %OUTFILE%
REM 生成バッチを実行.
call %OUTFILE%
REM del %OUTFILE%