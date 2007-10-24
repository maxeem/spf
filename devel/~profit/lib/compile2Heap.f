\ ���������� ���� � ����. ������ ���������� ������� (�������) �� ���� 
\ ����������. ����� ���������� ������������ ����������. "���������" 
\ �������� ����� �� ����������.

\ �������� ������������ ���������:
\ <��������-��-���������-���������> <������-������> _CREATE-VC ( xt n -- v_codefile )
\ ��� <��������-��-���������-���������> ����������� ����� ���� ��� ���������� 
\ ��� ����� ����

\ v_codefile -- ����� "������������ ���������", � ���������� ������ vc

\ ���� �� ���� ������������� � �������� RET ��� ������ ����������� �������
\ ������ �� ����������� �� <��������-��-���������-���������> �� ����������.

\ �������� ��������� �� ���������� ��-��������� (�������������):
\ CREATE-VC ( -- vc )
\ ������ ������ �������� � ����������� �� �������� �������, ������ 
\ -- 4��. �������� �� ��������� -- NOOP.

\ VC-, VC-COMPILE, VC-LIT, VC-RET, ����������
\ ,    COMPILE,    LIT,    RET,
\ ������ ������� �������������� �������� -- vc
\ , �� ���� �������� ���� ��� ����������

\ ���� ����� ����� VC-COMPILED ( addr u vc -- )
\ ������� _�����������_ ������� ����� � ���� ������ addr u
\ � �������� vc.
\ ����� �������� �� ����� ���������� � �����������������.

\ ��������: "�����" ����� ����������� �� �����������
\ ���������� �� ���������, �� ���� ��������, ������� ��������:
\ S" BEGIN ... WHILE " vc VC-COMPILED 
\ � �����:
\ S" ... REPEAT" vc VC-COMPILED
\ ��� ��� ���� �������� ���������� �� �����������.

\ TODO: ��������� ���� �������� ���������� (control-flow stack)
\ �������� ��� ������� ���������

\ TODO: CASE ... ENDCASE ?


\ ����� VC- ( vc --> \ <-- ) ����������� ��� ������������� �����,
\ ������ ����� ����, �� ����������� �������� vc � �������� �����������

\ �������� ���������������� � �������� ��� ����� ���:
\ vc XT-VC EXECUTE
\ ����:
\ vc EXECUTE

\ �� ���� ����� ���������� (SEE) ��� �� �������� ���� ��� ���
\ vc XT-VC REST
\ �������, ��������� vc EXECUTE �����.

\ ����� ������ ���������� � vc , ��� ����� ����� ��������� ��� 
\ �������������� ���������. �� ����:

\ CREATE-VC VALUE vc
\ 1 vc VC-LIT,
\ vc EXECUTE .
\ �����: 1

\ ' 1+ vc VC-COMPILE,
\ vc EXECUTE .
\ �����: 2

\ ��� ����� ������������� � ������������� DESTROY-VC ( vc -- )

\ REQUIRE MemReport ~day/lib/memreport.f
REQUIRE PageSize ~profit/lib/get-system-info.f
REQUIRE /TEST ~profit/lib/testing.f
REQUIRE __ ~profit/lib/cellfield.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE REPLACE-WORD lib/ext/patch.f

MODULE: codepatches

PageSize CELL - CONSTANT MEM-PAGE

MM_SIZE 2 CELLS MAX 32 MAX 2* CONSTANT luft  \ ������� ���� �������

0
1 -- rlit     \ ���������� PUSH (0x68)
__ firstBlock \ ������ ���� ������� ��� �������� ������
1 -- ret      \ ���������� RET (0xC3)
__ALIGN       \ ����������� �� ������
__ block      \ ������ ������, �������� ���� ����� ������ ��� ����
__ there      \ ����������� HERE � ���� ����������� ���������
__ lastBlock  \ ��������� �����
__ limit      \ ��������� ����������, ���� ������������ ���������
              \ �����, ����� ����������� �������� ���� �������� ����� ����
__ end-vc     \ ��������, ����������� ����� ��������� ���� ������ vc
CONSTANT codePatches

\ ���� firstBlock ��������� ������������ ��������� ��������� ��
\ ������, ��������� ������ ������ ����. ������ �� ��� ����� �
\ ������ ���������:
\ ---------------- ������ �����
\ ������ �����
\ ----------------
\ ... ����� ��� ��� �����
\ ... NOP'�-��������
\ ---------------- ������ ���������� �������� ����� ����� �����
\ 0x68 ���. ������� PUSH
\ nextBlock -- ���� �������� ����� ���������� �����
\ 0x�3 ���. ������� RET
\ ---------------- ����� �����

\ ��������� ����� ����� �����
0
__ blockSize   \ ������ �����
__ blocks'Code \ ������ ���������� ��� � ��� ������ end-struc
DROP

\ �������� ����� ����� �����
0
1 -- rlit0     \ ���������� PUSH (0x68)
__ nextBlock0  \ ����. ����� ���������, ���� �����
1 -- ret0      \ ���������� RET (0xC3)
CONSTANT end-struc

USER vc \ ������� ����������� ��������

\ �� ������ ��� ������ ����� ��������� ����� ������ ��������� ������ ����� �����
: end-struct-addr ( addr1 -- addr2 ) DUP blockSize @ + end-struc - ;

\ ����� ��� ���������� ������� ����� � �������� ����� �� ������ ������ �����
: rlit1 ( addr1 -- addr2 ) end-struct-addr rlit0 ;
: ret1 ( addr1 -- addr2 ) end-struct-addr ret0 ;
: nextBlock ( addr1 -- addr2 ) end-struct-addr nextBlock0 ;

\ VARIABLE counter counter 0!

\ ������ � �������� ������ ����� ����
: allocatePatch ( vc -- block ) >R
R@ block @ ALLOCATE THROW ( �����-����� R: �����-���������-��������� )
\ counter 1+!  counter @ CR .  \ ��� �������� ������ � ������ ������
DUP R@ lastBlock !             \ � ��������� ��������� ��������� ����� ��������� ����� ����
DUP R@ block @ 0x90 FILL       \ ��������� ���� ����� ���. ��������� NOP
R@ block @ OVER blockSize !    \ � ������ ����� ����������� ��� ������
0x68 OVER rlit1 C!             \ ��������� � ��� ������ ���. �������
0xC3 OVER ret1 C!              \ ��������� � ��� ������ ���. �������
R@ end-vc @ OVER nextBlock !   \ ��������� ����� ���� ������ ��������� �� �������� ��������
DUP blocks'Code R@ there !     \ ���������� ��������� HERE ��������� �� ������ ������ ����� ����
DUP R@ block @ + luft -        \ ��������� ����� ������ ����� � ������ � ������ ����� "������", ����
R@ limit !                     \ ��������� ������� �������� ����� ���������
RDROP ;

:NONAME  ( -- )       \ ���������� ����������
HERE vc @ limit @ < IF EXIT THEN \ �������� �� ����� �� ������� �������� ����� ���������
\ ���� ����. �������� �� �������� ���, �� ����� ��������� ��� ����� ����
\ HERE 1- C@ 0= IF 0 HERE 1- C! THEN
HERE MM_SIZE CELL+ 2 CELLS MAX 0x90 FILL \ ��� ������ ������������ ������� "���������" ���. ����������, ��������� ������������ ������� 0x00
vc @ lastBlock @                 \ ���������� ������� ���� � ������� �������������
vc @ allocatePatch ( block )     \ ���� �� ���� ����� ����
blocks'Code SWAP nextBlock !     \ ��������� ����� ���� ���� � ����������
vc @ there @ DP !
; CONSTANT VC-CHECK

: firstBlock! ( xt vc -- ) SWAP blocks'Code SWAP firstBlock ! ;
: firstBlock@ ( vc -- xt ) firstBlock @ 0 blocks'Code - ;

EXPORT

' NOOP ->VECT ON-COMPILE-START ( xt -- xt )

: INLINE2, ( CFA --  ) ON-COMPILE-START  OPT_INIT  _INLINE, OPT_CLOSE ;

' INLINE2, ' INLINE, REPLACE-WORD \ �������� ��������� �������� ������ ����������� ���. ����
\ �������� �� �� ��� 

: COMPILE2,  \ 94 CORE EXT
    ON-COMPILE-START
    CON>LIT 
    IF  INLINE?
      IF     INLINE,
      ELSE   _COMPILE,
      THEN
    THEN
;
' COMPILE2, ' COMPILE,  REPLACE-WORD \ �������� ��������� �������� ����������

: _CREATE-VC ( end-vc blockSize -- vc )
codePatches ALLOCATE THROW >R
0x68 R@ rlit C!
0xC3 R@ ret C!
R@ block !
R@ end-vc !
R@ allocatePatch R@ firstBlock!
R> ;

: CREATE-VC (  -- vc ) ['] NOOP MEM-PAGE _CREATE-VC ; \ ��-��������� ����� �� ������� ������ ���������� ���������� �� ����

: DESTROY-VC ( vc -- )
DUP end-vc @ SWAP DUP firstBlock@ blocks'Code ( end-vc vc xt )
SWAP FREE THROW \ ����������� ����������� ��������� ���������
BEGIN
0 blocks'Code - \ �� xt ��������� � ������ ����� ����, ��� ����� ������� �����
DUP nextBlock @
SWAP FREE THROW
\ -1 counter +!  counter @ CR . \ ��� �������� ������ � ������ ������
2DUP = UNTIL 2DROP ;


: XT-VC ( vc -- xt ) firstBlock@ blocks'Code ;
\ : XT-VC ( vc -- xt ) ; \ ����� � ���, �� ������������ ����� ���������� ����� ������ �������...


: VC- ( ... vc --> \ <-- ) PRO
DUP vc B! \ ��������� ������� ����. �������� � ���������� ������� ����������
there @ DP B! \ ������ � ���������� DP � ��������������� ��� ������
ClearJpBuff \ ��� ��� �� ������ ��������� ��� � ������ ���������, ��
\ �������� ������� ��� �� ����� ("�����������" ��� J_@ ������� ��
\ ��������� ����������� ������������ DP )
\ ��� �������� �������� �����������:
10 0 DO SetOP LOOP \ ���������� ������� ���������� �������� �� ���� � ��� �� ������� HERE
HERE DUP TO LAST-HERE DUP TO :-SET TO J-SET \ ���������� ������� �������� � ����������� ��������� �� ������� HERE
['] ON-COMPILE-START CFL + KEEP \ ��������� ������ �������� ��������
VC-CHECK TO ON-COMPILE-START \ �������� �������� ���������� �� ����� ���������� ������������ ���������
\ BACK TO MM_SIZE TRACKING MM_SIZE BDROP  0 TO MM_SIZE \ ������������ ������ �����������, �������� ��� ������
CONT \ �����
HERE MM_SIZE CELL+ 2 CELLS MAX 0x90 FILL \ ��� ������ ������������ ������� "���������" ���. ����������, ��������� ������������ ������� 0x00
HERE vc @ there ! ; \ ���������� HERE ������������ ��������� �����
\ ���������� � ����

: VC-COMPILE, ( xt vc -- ) VC- COMPILE, ;
: VC-POSTPONE ( vc "word" -- ) ?COMP ' LIT, POSTPONE SWAP POSTPONE VC-COMPILE, ; IMMEDIATE
: VC-, ( n vc -- ) VC- , ;
: VC-LIT, ( n vc -- ) VC- LIT, ;
: VC-DLIT, ( du vc -- ) >R SWAP R@ VC-LIT, R> VC-LIT, ;
: VC-RET, ( vc -- ) VC- POSTPONE EXIT ;

\ ���������� ������ � ���� ������ � ����:
: VC-COMPILED ( addr u vc -- ) VC- TRUE STATE B! EVALUATE ;

;MODULE


/TEST

REQUIRE TYPE>STR ~ygrek/lib/typestr.f
REQUIRE TESTCASES ~ygrek/lib/testcase.f


0 VALUE t

: numb3rs  S" 1 2 3 4 5 6" EVALUATE ; IMMEDIATE

: simple-numb3rs  numb3rs ;

: numb3rs-in-heap
CREATE-VC TO t
START{ t VC- numb3rs }EMERGE
t VC-RET,
t XT-VC EXECUTE
t DESTROY-VC ;



: loop S" 10 1 DO I DUP * . LOOP " EVALUATE ; IMMEDIATE

: simple-loop  1000 0 DO loop LOOP ;

: compile-loop-in-heap
CREATE-VC TO t
1000 0 DO
START{ t VC- loop }EMERGE
LOOP
t VC-RET,
t XT-VC EXECUTE
t DESTROY-VC ;


TESTCASES compile to heap test

CREATE-VC TO t
1 t VC-LIT,
2 t VC-LIT,
3 t VC-LIT,
(( t EXECUTE -> 1 2 3 ))
t DESTROY-VC

(( numb3rs-in-heap -> simple-numb3rs ))

' simple-loop TYPE>STR
' compile-loop-in-heap TYPE>STR
2DUP
STR@ ROT STR@ TEST-ARRAY

STRFREE STRFREE


END-TESTCASES 

\ MemReport