\ 2006-12-09

\ ������ਨ ------------------------------------------------------------------

\ ��� �뢮�� ᮮ�饭�� � ������砥��� ᥪ樨
\ 㤮��� �ᯮ�짮���� � ��砫� 䠩��
: \. 0x0A PARSE CR TYPE ;

\ ������਩ �� ���� ��ப� (��� �६������ ������஢���� ��᪮� ����)
: \? ( --> ) [COMPILE] \ ; IMMEDIATE

\ ���⥪�� --------------------------------------------------------------------

\ ��⠢��� � ���⥪�� ⮫쪮 ᠬ� ���孨� ᫮����
: SEAL CONTEXT @ ONLY CONTEXT ! ;

\ �⥪��� �������樨 --------------------------------------------------------

\ �������� ���祭�� ������ �� ���設� �⥪� � ���祭��� ��६�����
: change ( n addr --> [addr] ) DUP @ -ROT ! ;

\ ���᫨�� �࠭��� ���ᨢ� ��������� ᢮�� ���ᮬ � �������
: boudns ( addr # --> up low ) OVER + SWAP ;

\ ������� �� ���祭�� � �⥪� ������
: 3DROP ( n n n --> ) 2DROP DROP ;

\ �����᪨� ����樨 ---------------------------------------------------------

\ ������� �� ������ ��� ��� ����
: ?BIT  ( N --> mask ) 1  SWAP LSHIFT ;

\ ������� �� ������ ��� ��� �������� ����
: N?BIT ( N --> mask ) ?BIT INVERT ;

\ ����� ----------------------------------------------------------------------

\ ᫮�� �⪠�뢠�� >IN �����, �� ��砫� ������⮣� ᫮��
: <back ( ASC # --> ) DROP TIB - >IN ! ;
