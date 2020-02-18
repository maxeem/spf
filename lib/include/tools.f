\ 94 TOOLS

: .S ( -- ) \ 94 TOOLS
\ ����������� � �������� ��������, ����������� �� ����� ������. ������ ������� 
\ �� ����������.
\ .S ����� ���� ����������� � �������������� ���� ���������� �������������� 
\ �����. ��������������, �� ����� ��������� ������������ �������, 
\ ���������������� #>.
   DEPTH 0 MAX .SN
;

: ? ( a-addr -- ) \ 94 TOOLS
\ �������� ��������, ���������� �� ������ a-addr.
\ ? ����� ���� ���������� � �������������� ���� ���������� �������������� 
\ �����. ��������������, �� ����� ��������� ������������ �������, 
\ ���������������� #>.
  @ .
;
: AHEAD  \ 94 TOOLS EXT
\ �������������: ��������� ������������.
\ ����������: ( C: -- orig )
\ �������� ����� ������������� ������ ������ orig �� ���� ����������.
\ �������� ��������� ������� ����������, ������ ����, � �������� �����������.
\ ��������� ����������� �� ��� ���, ���� orig �� ���������� (��������,
\ �� THEN).
\ ����� ����������: ( -- )
\ ���������� ���������� � �������, �������� ����������� orig.
  HERE BRANCH, >MARK 2
; IMMEDIATE

: [ELSE]   \ 94 TOOLS EXT
\ ����������: ��������� ��������� ����������, ������ ����.
\ ����������: ( "<spaces>name..." -- )
\ ���������� ������� �������, �������� � ��������� ������������ ��������� 
\ ����� �� ����������� �������, ������� ��������� [IF]...[THEN] � 
\ [IF]...[ELSE]...[THEN], �� ��������� � ������������ ����� [THEN].
\ ���� ����������� ������� ������������, ��� ����� ����������� �� REFILL.
\ [ELSE] - ����� ������������ ����������.
    1
    BEGIN
      NextWord DUP
      IF  
         2DUP S" [IF]"   COMPARE 0= IF 2DROP 1+                 ELSE 
         2DUP S" [ELSE]" COMPARE 0= IF 2DROP 1- DUP  IF 1+ THEN ELSE 
              S" [THEN]" COMPARE 0= IF       1-                 THEN
                                    THEN  THEN   
      ELSE 2DROP REFILL  AND \   SOURCE TYPE
      THEN DUP 0=
    UNTIL  DROP ;  IMMEDIATE

: [IF] \ 94 TOOLS EXT
\ ����������: ��������� ��������� ����������, ������ ����.
\ ����������: ( flag | flag "<spaces>name..." -- )
\ ���� ���� "������", ������ �� ������. �����, ��������� ������� �������, 
\ �������� � ����������� ������������ ��������� ����� �� ����������� �������,
\ ������� ��������� [IF]...[THEN] � [IF]...[ELSE]...[THEN], �� ��� ���, ���� �� 
\ ����� �������� � ��������� ����� [ELSE] ��� [THEN].
\ ���� ����������� ������� ������������, ��� ����� ����������� �� REFILL.
\ [ELSE] - ����� ������������ ����������.
  0= IF POSTPONE [ELSE] THEN
; IMMEDIATE

: [THEN] \ 94 TOOLS EXT
\ ����������: ��������� ��������� ����������, ������ ����.
\ ����������: ( -- )
\ ������ �� ������. [THEN] - ����� ������������ ����������.
; IMMEDIATE


: CS-PICK ( C: destu ... orig0|dest0 -- destu ... orig0|dest0 destu ) ( S: u -- ) \ 94 TOOLS EXT
  2* 1+ DUP >R PICK R> PICK
;

: CS-ROLL ( C: origu|destu origu-1|destu-1 ... orig0|dest0 -- origu-1|destu-1 ... orig0|dest0 origu|destu ) ( S: u -- ) \ 94 TOOLS EXT
  2* 1+ DUP >R ROLL R> ROLL
;


\ Ruvim Pinka additions:

: [DEFINED] ( -- f ) \ "name"
  NextWord  SFIND  IF DROP TRUE ELSE 2DROP FALSE THEN
; IMMEDIATE

: [UNDEFINED]  ( -- f ) \ "name"
  POSTPONE [DEFINED] 0=
; IMMEDIATE



[DEFINED] PLATFORM [IF]
\ NB: PLATFORM is missed in SPF/3.75c that is used to build SPF/4

: OS_LINUX ( -- flag )
  PLATFORM S" Linux" COMPARE 0=
;
: OS_WINDOWS ( -- flag )
  OS_LINUX 0=
;

[THEN]
