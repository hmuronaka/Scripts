REM filelist.rb�p�̃o�b�`�t�@�C��

REM ^���o�͂���ۂ�^^�Ƃ��邱��.
REM |���o�͂���ۂ�^|�Ƃ��邱��.

REM �o�͑ΏۊO�Ƃ���t�@�C���p�^�[��
set EXCLUDE_FILE=(^^�R�s�[^|.*vshost.*^|history.dat)

REM �o�͑ΏۊO�Ƃ���g���q�p�^�[��
set EXCLUDE_EXTENSION=\.(pdb^|tlog^|lnk^|bmp)$
ruby filelist.rb src\ > result.csv
ruby filelist.rb data >> result.csv
