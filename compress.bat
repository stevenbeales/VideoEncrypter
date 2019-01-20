pushd "%~dp0"
echo
echo "compressing video file"
videocompressor.exe -i %1 %2
popd