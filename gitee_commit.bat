@echo off 
set input=
set /p input=�������ַ���:
echo ��������ַ����ǣ�%input%
git add .
git commit -m %input%
git push origin
pause