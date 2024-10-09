@ECHO OFF
PUSHD "%~dp0"

echo This script should be run with administrator privileges.
echo Right click - run as administrator.
echo Press any key if you're running it as administrator.
pause

sc query ZapretService >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    sc stop "ZapretService"
    sc delete "ZapretService"
)

sc create "ZapretService" binPath= "\"%CD%\winws.exe\" --wf-tcp=80,443 --wf-udp=443-65535 --filter-udp=443 --hostlist=\"%CD%\websites.txt\" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=\"%CD%\quic_initial_www_google_com.bin\" --new --filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-fake-quic=\"%CD%\quic_initial_www_google_com.bin\" --new --filter-tcp=443 --hostlist=\"%CD%\websites.txt\" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls=\"%CD%\tls_clienthello_www_google_com.bin\" --new --dpi-desync=disorder2 --new" start= "auto"
sc description "ZapretService" "Service for DPI circumvention and traffic filtering"
sc start "ZapretService"

POPD
