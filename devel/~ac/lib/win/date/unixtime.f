\ CurrentTimeSql ���� ��������� ����-����� � ������� 2005-12-06 10:33:07

WINAPI: time MSVCRT.DLL
WINAPI: strftime  MSVCRT.DLL
WINAPI: localtime  MSVCRT.DLL
\ WINAPI: clock MSVCRT.DLL
\ clock .

: UnixTime ( -- n ) 0 >R RP@ time NIP RDROP ;

USER-CREATE uLocalTime 21 USER-ALLOT

: UnixTimeSql ( unixtime -- addr u ) \ LOCAL
  >R RP@ localtime NIP 
  S" %Y-%m-%d %H:%M:%S" DROP 21 uLocalTime strftime NIP NIP NIP NIP 
  uLocalTime SWAP
  RDROP
;
: CurrentTimeSql ( -- addr u )
  UnixTime UnixTimeSql
;
\ CurrentTimeSql TYPE

: UNIXTIME>FILETIME ( unixtime -- filetime ) \ UTC
  10000000 M* 116444736000000000. D+  \ ��. http://support.microsoft.com/kb/167296
;
