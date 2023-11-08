\ $Id$

( ������ ������ ���� ������� - WORDS.
  ��-����������� �����������.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  �������������� �� 16-���������� � 32-��������� ��� - 1995-96��
  ������� - �������� 1999
)

USER >OUT
USER W-CNT

: NLIST ( wid -- )
  LATEST-NAME-IN ( nt|0 )
  >OUT 0! CR W-CNT 0!
  BEGIN
    DUP KEY? 0= AND
  WHILE
    W-CNT 1+! 
    DUP C@ >OUT @ + 74 >
    IF CR >OUT 0! THEN
    DUP ID.
    DUP C@ >OUT +!
    15 >OUT @ 15 MOD - DUP >OUT +! SPACES
    NAME>NEXT-NAME
  REPEAT DROP KEY? IF KEY DROP THEN
  CR CR ." Words: " BASE @ DECIMAL W-CNT @ U. BASE ! CR
;

: WORDS ( -- ) \ 94 TOOLS
\ ������ ���� ����������� � ������ ������ ���� ������� ������. ������ ������� 
\ �� ����������.
\ WORDS ����� ���� ���������� � �������������� ���� ���������� �������������� 
\ �����. ��������������, �� ����� ��������� ������������ �������, 
\ ���������������� #>.
  CONTEXT @ NLIST
;
