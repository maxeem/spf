( ���������� �������.
  Windows-��������� �����.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  ������� - �������� 1999
)
\ 94 MEMORY

USER THREAD-HEAP   \ ����� ���� �������� ������

VARIABLE USER-OFFS \ �������� � ������� ������ ������, 
                   \ ��� ��������� ����� ����������

: ERR
  IF 0 ELSE GetLastError THEN
;
: USER-ALLOT ( n -- )
  USER-OFFS +!
;
: USER-HERE ( -- n )
  USER-OFFS @
;

HEX
: CREATE-HEAP ( -- )
\ ������� ��� �������� ������.
  0 8000 0 HeapCreate >R
  USER-OFFS @ 4000 + 8 R@ HeapAlloc CELL+ TlsIndex!
  R> THREAD-HEAP !
  R> R@ TlsIndex@ CELL- ! >R
;
DECIMAL

: DESTROY-HEAP ( -- )
\ ���������� ��� �������� ������.
  THREAD-HEAP @ HeapDestroy DROP
;

: ALLOCATE ( u -- a-addr ior ) \ 94 MEMORY
\ ������������ u ���� ������������ ������������ ������. ��������� ������������ 
\ ������ �� ���������� ���� ���������. �������������� ���������� ����������� 
\ ������� ������ ������������.
\ ���� ������������� �������, a-addr - ����������� ����� ������ �������������� 
\ ������� � ior ����.
\ ���� �������� �� ������, a-addr �� ������������ ���������� ����� � ior - 
\ ��������� �� ���������� ��� �����-������.

\ SPF: ALLOCATE �������� ���� ������ ������ ����� �������� ������
\ ��� "��������� �����" (��������, �������� ������ ���������� �������)
\ �� ��������� ����������� ������� ���� ���������, ��������� ALLOCATE

  CELL+ 8 ( HEAP_ZERO_MEMORY) THREAD-HEAP @ HeapAlloc
  DUP IF R@ OVER ! CELL+ 0 ELSE -300 THEN
;

: FREE ( a-addr -- ior ) \ 94 MEMORY
\ ������� ����������� ������� ������������ ������, ������������ a-addr, ������� 
\ ��� ����������� �������������. a-addr ������ ������������ ������� 
\ ������������ ������, ������� ����� ���� �������� �� ALLOCATE ��� RESIZE.
\ ��������� ������������ ������ �� ���������� ������ ���������.
\ ���� �������� �������, ior ����. ���� �������� �� ������, ior - ��������� �� 
\ ���������� ��� �����-������.
  CELL- 0 THREAD-HEAP @ HeapFree ERR
;
: RESIZE ( a-addr1 u -- a-addr2 ior ) \ 94 MEMORY
\ �������� ������������� ������������ ������������ ������, ������������� � 
\ ������ a-addr1, ����� ��������������� �� ALLOCATE ��� RESIZE, �� u ����.
\ u ����� ���� ������ ��� ������, ��� ������� ������ �������.
\ ��������� ������������ ������ �� ���������� ������ ���������.
\ ���� �������� �������, a-addr2 - ����������� ����� ������ u ���� 
\ �������������� ������ � ior ����. a-addr2 �����, �� �� ������, ���� ��� �� 
\ �����, ��� � a-addr1. ���� ��� �����������, ��������, ������������ � ������� 
\ a-addr1, ���������� � a-addr2 � ���������� ������������ �� �������� ���� 
\ ���� ��������. ���� ��� ���������, ��������, ������������ � �������, 
\ ����������� �� ������������ �� u ��� ��������������� �������. ���� a-addr2 �� 
\ ��� ��, ��� � a-addr1, ������� ������ �� a-addr1 ������������ ������� 
\ �������� �������� FREE.
\ ���� �������� �� ������, a-addr2 ����� a-addr1, ������� ������ a-addr1 �� 
\ ����������, � ior - ��������� �� ���������� ��� �����-������.

\  SWAP CELL- 8 ( HEAP_ZERO_MEMORY) THREAD-HEAP @ HeapReAlloc
\  DUP IF CELL+ 0 ELSE -300 THEN
\  ���������� ~day, 14.01.02

  CELL+ SWAP CELL- 8 ( HEAP_ZERO_MEMORY) THREAD-HEAP @ HeapReAlloc
  DUP IF CELL+ 0 ELSE -300 THEN

;
