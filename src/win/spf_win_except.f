\ $Id$

( ��������� ���������� ���������� [������� �� ����, ���������
  �� ������������ �������, � �.�.] - ����� �������� � THROW.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  C������� 1999
)

   H-STDIN  VALUE  H-STDIN    \ ����� ����� - ������������ �����
   H-STDOUT VALUE  H-STDOUT   \ ����� ����� - ������������ ������
   H-STDERR VALUE  H-STDERR   \ ����� ����� - ������������ ������ ������
          0 VALUE  H-STDLOG


: AT-THREAD-FINISHING ( -- ) ... ;
: AT-PROCESS-FINISHING ( -- ) ... DESTROY-HEAP ;

: HALT ( ERRNUM -> ) \ ����� � ����� ������
  AT-THREAD-FINISHING
  AT-PROCESS-FINISHING
  ExitProcess
;

USER EXC-HANDLER  \ ���������� ���������� (������������� � �����������)

( DispatcherContext ContextRecord EstablisherFrame ExceptionRecord ExceptionRecord --
  DispatcherContext ContextRecord EstablisherFrame ExceptionRecord )
VECT <EXC-DUMP> \ �������� �� ��������� ����������

: (EXC) ( DispatcherContext ContextRecord EstablisherFrame ExceptionRecord -- flag )
  (ENTER) \ ����� ��� ����� ������
  \ 0 FS@ \ ����� ���������� ������������ ������ ��������� ����������, EXCEPTION_REGISTRATION
  \ @ -- ����� ���������� ������, ��� -1 ���� ������ ����� ���������
  \ See-also: http://bytepointer.com/resources/pietrek_crash_course_depths_of_win32_seh.htm
  \   Matt Pietrek, "A Crash Course on the Depths of Win32� Structured Exception Handling�
  OVER \ EstablisherFrame - ��� �����
  DUP 0 FS! \ ��������������� ��� �����, ����� ���������� ������ exceptions � �������
  CELL+ CELL+ @ TlsIndex! \ ����� ����������� ��������� �� USER-������ �������� ������

\  2DROP 2DROP
\  0 (LEAVE)               \ ��� ���� ����� �������� ��������� ����

  ( ExceptionRecord )
  DUP @ 0xC000013A = IF \ CONTROL_C_EXIT - Ctrl+C on wine
    0xC000013A HALT
  THEN
  DUP <EXC-DUMP>

  HANDLER @ 0=
  IF \ ���������� � ������, ��� CATCH, ������ ����� � ��������� (~day)
     DESTROY-HEAP
     -1 ExitThread
  THEN

  FINIT \ ���� float ����������, ���������������

  ( ExceptionRecord )
  @ THROW  \ ���������� ���������� � ������ �������� :)
  R> DROP   \ ���� ��� �� ���������, �� �������� ������� �� callback
;

: DROP-EXC-HANDLER
  R> 0 FS! RDROP RDROP
;
: SET-EXC-HANDLER
  R> R>
  TlsIndex@ >R
  ['] (EXC) >R
  0 FS@ >R
  RP@ 0 FS!
  RP@ EXC-HANDLER !
  ['] DROP-EXC-HANDLER >R \ ������������� ����� ����� ��������.����������
  >R >R
;
' SET-EXC-HANDLER ' <SET-EXC-HANDLER> TC-VECT!
