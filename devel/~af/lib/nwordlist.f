\ ����������� ��������. � ������� � �������� ���� ���� ������������ �����.
\ ����� ������������ ( ��������) ��� ������ ������������ ���-���������
\ � ���� ����.

: SEARCH-NLIST ( msg wid -- 0 | xt 1 )
  \ ����� n-�����
  SWAP >R  RP@ 4  ROT  SEARCH-WORDLIST  RDROP
;

: +NWORD ( n wid -> )
  HERE LAST !
  HERE ROT 4 C, , SWAP DUP @ , !
;

: NHEADER ( n -- )
  HERE 0 , ( cfa )
  DUP LAST-CFA !
  0 C,     ( flags )
  SWAP WARNING @
  IF DUP GET-CURRENT SEARCH-NLIST
     IF DROP DUP . ."  isn't unique" CR THEN
  THEN
  GET-CURRENT +NWORD
  ALIGN
  HERE SWAP ! ( ��������� cfa )
;

: :M ( "WM_..." -- )
  \ ���������� ���������� ���������
  NHEADER
  ]
  HIDE
;
