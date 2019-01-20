pushd "%~dp0"
winscp.com /script="script.txt" /ini=%2.ini  /parameter %1 %2
popd