\ $Id$
( ���������� �������.
  Windows-��������� �����.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  ������� - �������� 1999
)
\ 94 MEMORY


0 CONSTANT FORTH-START
.forth >VIRT ' FORTH-START >BODY !

0x80000 VALUE IMAGE-SIZE

VARIABLE THREAD-HEAP \ ��� ������������� � windows-�������, �������� ������� �������� �� ����

USER THREAD-MEMORY   \ ������ �������� ������

VARIABLE USER-OFFS \ �������� � ������� ������ ������, 
                   \ ��� ��������� ����� ����������

VARIABLE calloc-adr

: errno ( -- n)
  (()) __errno_location @
;

: ?ERR ( -1/n -- x err / n 0)
  DUP -1 = IF errno ELSE 0 THEN
;

: USER-ALLOT ( n -- )
  USER-OFFS +!

\ ��������� � USER-CREATE ~day 
\  USER-OFFS @ +   \ � ������ ����������
\  CELL 1- +  [ CELL NEGATE ] LITERAL AND \ ����� �����������
\  USER-OFFS !
;
: USER-HERE ( -- n )
  USER-OFFS @
;

VARIABLE EXTRA-MEM
0x4000 ' EXTRA-MEM EXECUTE !

: ALLOCATE-THREAD-MEMORY ( -- )
  USER-OFFS @ EXTRA-MEM @ CELL+ + 1 2 calloc-adr @ 
  C-CALL DUP
  IF
     DUP CELL+ TlsIndex!
     THREAD-MEMORY !
     R> R@ TlsIndex@ CELL- ! >R
  ELSE
     -300 THROW
  THEN
;

: FREE-THREAD-MEMORY ( -- )
\ ���������� ��� �������� ������ ��� ��������
  (( THREAD-MEMORY @ )) free DROP
;


: (FIX-MEMTAG) ( addr -- addr ) 2R@ DROP OVER CELL- ! ;

: FIX-MEMTAG ( addr-allocated -- ) (FIX-MEMTAG) DROP ;

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

  CELL+ 1 SWAP 2 calloc-adr @ C-CALL
  DUP IF R@ OVER ! CELL+ ( ~~ FIX-MEMTAG ) 0 ELSE -300 THEN
;

: FREE ( a-addr -- ior ) \ 94 MEMORY
\ ������� ����������� ������� ������������ ������, ������������ a-addr, ������� 
\ ��� ����������� �������������. a-addr ������ ������������ ������� 
\ ������������ ������, ������� ����� ���� �������� �� ALLOCATE ��� RESIZE.
\ ��������� ������������ ������ �� ���������� ������ ���������.
\ ���� �������� �������, ior ����. ���� �������� �� ������, ior - ��������� �� 
\ ���������� ��� �����-������.
  CELL- 1 <( )) free DROP 0
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
  CELL+ SWAP CELL- SWAP 2 realloc-adr @ C-CALL
  DUP IF CELL+ 0 ELSE -300 THEN
;
