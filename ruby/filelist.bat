REM filelist.rb用のバッチファイル

REM ^を出力する際は^^とすること.
REM |を出力する際は^|とすること.

REM 出力対象外とするファイルパターン
set EXCLUDE_FILE=(^^コピー^|.*vshost.*^|history.dat)

REM 出力対象外とする拡張子パターン
set EXCLUDE_EXTENSION=\.(pdb^|tlog^|lnk^|bmp)$
ruby filelist.rb src\ > result.csv
ruby filelist.rb data >> result.csv
