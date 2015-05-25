\ Feb.2007 ruv
\ $Id$

\ ���� ����� ���� ������� � �������� xml-���� (cnode);
\ ����� ����, ���������� � ������� �����, ����� ������ ����� ���������,
\ � ������� �� ����������� ���� DOM, ��������� ���� ����� ����������.

\ ������� ������ cnode-a

TEMP-WORDLIST GET-CURRENT   OVER ALSO CONTEXT ! DEFINITIONS

\ ����� wrap � wrap2 ������ ��� �������� �������
\ � ������,  ������� �������������� 
\ ��������� ( i*x node -- j*x ) � ( i*x node -- j*x node|0 ).
\ ������� ������-��� ������������ � ������ R/W.

: wrap ( a u -- )
  CONCEIVE
    `cnode-a & EXEC,
    `@       & EXEC,
    2DUP     & EXEC,
  SWAP DUP C@ 32 - OVER C! SWAP
  BIRTH NAMING
;
: wrap2 ( a u -- )
  CONCEIVE
    `cnode-a & EXEC,
    `@       & EXEC,
     2DUP    & EXEC,
    `cnode-a & EXEC,
    `!       & EXEC,
  SWAP DUP C@ 32 - OVER C! SWAP
  BIRTH NAMING
;

SET-CURRENT

`nodeType       wrap
`nodeName       wrap
`nodeValue      wrap
\ `ownerDocument  wrap  \ �� ���� doc, � �� node
`prefix         wrap
`namespaceURI   wrap

`parentNode     wrap2
`firstChild     wrap2
`lastChild      wrap2
`nextSibling    wrap2
`previousSibling wrap2

`firstChildByTagName    wrap2
`firstChildByTagNameNS  wrap2
`nextSiblingByTagName   wrap2
`nextSiblingByTagNameNS wrap2
`nextSiblingEqualNS     wrap2

`getAttribute   wrap
`getAttributeNS wrap
`hasAttribute   wrap
`hasAttributeNS wrap
`hasChildNodes  wrap
`firstChildValue wrap
`baseURI        wrap

`namespace-uri-for-prefix wrap

: ElementText ( -- addr u )
  cnode-a @ firstChild DUP IF nodeValue EXIT THEN 0 ( -- 0 0 )
;

: NodeName ( -- d-txt )
  NodeType PROCESSING_INSTRUCTION_NODE <> IF
    NodeName EXIT
  THEN
  `#processing-instruction
;

\ : mount ( node -- ) cnode-a ! ;
\ : dismount ( -- node ) cnode-a @ cnode-a 0! ;

: cnode  ( -- node ) cnode-a @ ;
: cnode! ( node -- ) cnode-a ! ;

: GetAttribute? ( -- a u true | false )
  2DUP HasAttribute IF GetAttribute TRUE EXIT THEN
  2DROP FALSE
;

: GetName ( -- a u ) `name GetAttribute ;
: GetName? ( -- a u true | false ) `name GetAttribute? ;

PREVIOUS FREE-WORDLIST
