\ 04-06-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ����� ������� ���� ��� ������ �� �������

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

\ -- �������� ����������� -----------------------------------------------------

\ �������� �������� ������ �� ������� ����� �� ��������� ����������
: change ( n addr --> [addr] ) DUP @ -ROT ! ;

\ ��������� ������� ������� ��������� ����� ������� � �������
: bounds ( addr # --> up low ) OVER + SWAP ;

\ �������� ��� �������� �� ����� ������
: 3DROP ( a b c --> ) 2DROP DROP ;

\ ���������� ��� ������� �������� �� ����� ���������
: 3DUP ( a b c --> a b c a b c ) >R 2DUP R@ -ROT R> ;

\ ������� � ������� ����� ��������� ����� ����������
: nDROP ( [ .. ] n --> ) 1 + CELLS SP@ + SP! ;

\ ������� ������ ������� ��������
: 2NIP ( da db --> db ) 2SWAP 2DROP ;

\ ����������� �������� �� �����������
: RANKING ( a b --> a b ) 2DUP MIN -ROT MAX ;

\ ��������� ����� base �� ��������� �������� n �
\ ������� ������������ ������������.
\ ������������ ������������ � ������� �������
: ROUND ( n base --> n ) TUCK 1 - + OVER / * ;

\ �������� �� ����� ������ ����� ��� ������
\ ������� �������������������� ������ � ��� ����� �� ������� �����
: FRAME ( # --> [frame] # ) >R SP@ R@ CELLS - SP! R> ;

\ -- ���������� �������� ------------------------------------------------------

\ �������� �� ������ ���� ��� �����
: ?BIT  ( N --> mask ) 1  SWAP LSHIFT ;

\ �������� �� ������ ���� ��� ��������� �����
: N?BIT ( N --> mask ) ?BIT INVERT ;

\ ������� TRUE ���� ����������� ������� a < ��� = b, ����� FALSE
: >= ( a b --> flag ) < 0= ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ��� ������ �������� �� ������������.
  S" passed" TYPE
}test
