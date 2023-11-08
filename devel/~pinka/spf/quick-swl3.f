\ 07.Jan.2004 ruv
\ 12.Oct.2005 branch from quick-swl2.f,v 1.3
\ $Id$

( ���������� SPF [������� �� ����������!]
   ��������� ������� ����� �� ������� �� ���� ������������� ���-������.

  ���� 30-35% �������� �� ���������� ������������ �������� ������,
  �� 43% ����� � fix-refill.f.

  ���-������� ��������� �����������, �� SAVE �� �����������.

  �����������:
    ���-������� ������������� � ����� ���� ��������
    [����� �������� HEAP-ID  ~pinka/spf/mem.f]
    �������� ������ ���� ��������, ���� �� ������ FREE-WORDLIST 
    �� ������ TEMP-WORDLIST
)
( ������ �������������� FREE-WORDLIST [���� ���� AT-STORAGE-DELETING ],
  ������ SHEADER � ����� ":" ";" [����� �������].
  �������, ��� ������� ���������� �� ����, 
  ��� ��� ����� ����� ���� ������������ � ������������
  [ � ��� �����, �� locals.f ], �� ����� storage.f [!!!]

  Dec.2006: ��������� MARKER ������, �.�. �� ���-����� �� ����������� ������ ����.

  �������� ������ SEARCH-WORDLIST -- ����� ������ � ����������� �������� SPF.
)

REQUIRE HEAP-ID     ~pinka/spf/mem.f
REQUIRE [UNDEFINED] lib/include/tools.f
REQUIRE HASH!       ~pinka/lib/hash-table2.f 

REQUIRE WidExtraSupport ~pinka/spf/wid-extra.f

FORTH-WORDLIST VALUE w

[UNDEFINED] WL-#WORDS [IF]
: WL-#WORDS ( wid -- n )
  0 SWAP
  @     BEGIN
  DUP   WHILE
  SWAP 1+ SWAP
  CDR   REPEAT  DROP
;
[THEN]


MODULE: QuickSWL-Support

ALSO WidExtraSupport

: WID-CACHEA WID-CACHEA ;

PREVIOUS

EXPORT

 256 VALUE #WL-HASH
 \ ������ ���-������ ��� ����� ����������� ��������.
 \ ��� ������������� �� ����� AT-PROCESS-STARTING 
 \   ������ ������ ������� ��� 3*n, ��� n -����� ���� � �������.

DEFINITIONS

0 \ ext header  for wordlist \ allocating dinamically
 1 CELLS -- .hash
 1 CELLS -- .last
 1 CELLS -- .wid
CONSTANT /exth
( exth ����� ���� wid ����� ������� .wid
  � �� wid ����� �������� exth
)


: wid-exth? ( wid -- exth true | false )
  WID-CACHEA @ DUP IF TRUE EXIT THEN DROP FALSE
;

: wid-exth ( wid -- exth )
  DUP WID-CACHEA @ DUP IF NIP EXIT THEN  DROP
  ( wid )
  HEAP-ID >R  HEAP-GLOBAL

  DUP WL-#WORDS 3 * #WL-HASH UMAX new-hash
  /exth ALLOCATE THROW ( wid htbl exth )
  TUCK .hash !
  2DUP SWAP WID-CACHEA !
  TUCK .wid !  ( exth )

  R> HEAP-ID!
;
: WL-HASH ( wid -- hash-table )
  wid-exth .hash @
;
( ������, �.�. ������ ������������� ���-������� - ������ ���������� )

USER-VALUE hash

: update-hash ( exth -- )
  >R
  R@ .last  @
  R@ .wid @ LATEST-NAME-IN  ( nt2 nt )
  2DUP = IF 2DROP RDROP EXIT THEN
  \ ���� ������� ���� - 0 0 - ���� �����

  DUP NAME>CSTRING CHAR+ C@ 12 = IF
  \ �� ��������� ��������� �����, ���� ������ ( by HIDE )
    NAME>NEXT-NAME 2DUP = IF 2DROP RDROP EXIT THEN
  THEN

  DUP R@ .last !
  R> .hash @ TO hash

  HEAP-ID >R  HEAP-GLOBAL

  0 >R
  ( l2 l )          BEGIN
  2DUP <>           WHILE
  DUP >R NAME>NEXT-NAME
  DUP 0=            UNTIL THEN 2DROP
  ( )               BEGIN
  R> DUP            WHILE
  DUP NAME>STRING
  hash HASH!N       REPEAT DROP
  \ ��������� � ���-������� ���� � ��� �� �������, 
  \ � ������� ����� ����������� � �������

  R> HEAP-ID!
;

: update-wlhash ( wid -- )
  wid-exth update-hash
;

: update1-wlhash ( nfa wid -- )
  wid-exth DUP .last @     IF
  HEAP-ID >R  HEAP-GLOBAL
    .hash @    >R
    DUP NAME>STRING R> HASH!N
  R> HEAP-ID!              ELSE
  \ ����� ��� ��������� ������� ��� ����� �����������
  NIP update-hash          THEN
;

EXPORT

\ SEARCH-WORDLIST ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ 94 SEARCH

: QuickSWL ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ SWL
  WL-HASH ( c-addr u  h )
  HASH@N            IF
  DUP  NAME> 
  SWAP NAME>F C@
  &IMMEDIATE AND
  IF 1 ELSE -1 THEN 
  EXIT              ELSE 0 THEN
;

: REFRESH-WLHASH ( wid -- )
\ �������� ���-������� ������� (�� ������, ���� ��� ����� ������������..)
\ �������������� ��������, ���� �� ����� ���������� REFRESH-WLHASH 
\  ���������� ����� �� ������� wid.
  DUP
  HEAP-ID >R  HEAP-GLOBAL

  wid-exth DUP
  .last 0!
  .hash @ clear-hash

  R> HEAP-ID!
  update-wlhash
;
: REFRESH-WLCACHE REFRESH-WLHASH ;

: DEL-WLHASH ( wid -- )
  wid-exth? 0= IF EXIT THEN
  HEAP-ID >R  HEAP-GLOBAL
     ( exth ) >R
     R@ .hash @ del-hash
     R@ .wid  @ WID-CACHEA 0!
     R> FREE THROW
  R> HEAP-ID!
;


[DEFINED] AT-STORAGE-DELETING [IF]

..: AT-STORAGE-DELETING ['] DEL-WLHASH ENUM-VOCS-FORTH ;..

[ELSE]

WARNING @ WARNING 0!

: FREE-WORDLIST ( wid -- )
  DUP DEL-WLHASH  FREE-WORDLIST
;

WARNING !

[THEN]


DEFINITIONS

: WID-CACHEA0! ( wid -- )
  WID-CACHEA 0!
;
: erase-refer ( -- )
\ ( ���������� ERASE-IMPORTS )
\ ���-������� ������������, ����� ������ � ��,
\ ������� ����� ������� �������� ������ �� exth � ���������� ��������
\ ����� �� �������������. �� ���� ��������. 
  ['] WID-CACHEA0! ENUM-VOCS-FORTH
;

: update-hashes ( -- )
\ ���������� ���-������� ��� ���� �������� (�� ������ VOC-LIST)
  ['] update-wlhash ENUM-VOCS-FORTH
;
( ���������� ���-������� �� ������� ������ � �������
  ������� ������������� ��� ����������������� � ���������������,
  �� ������������.

  ������������� ���������� ���� ������ �������� �� �����������
  �� ������ ������������� ����������.

  ��� �������, ����� ������������ ���, � ������� ������� ���������,
  � ������� �������.
)

VECT 0SWL  \ ����.-�� ������ QuickSWL  ��� ������� �������..

: 0SWL1 ( -- )
  erase-refer
  update-hashes
; ' 0SWL1 TO 0SWL

..: AT-PROCESS-STARTING 0SWL ;..

\ -------------------------------

USER LAST-WID

: LatestWord2Hash ( -- )
  GET-CURRENT LATEST-NAME-IN ?DUP IF GET-CURRENT update1-wlhash THEN
;

USER-VALUE NOW-COLON?

: SHEADER(SWL) ( addr u -- )
  GET-CURRENT LAST-WID !

  [ ' SHEADER BEHAVIOR COMPILE, ]
  NOW-COLON?
  IF FALSE TO NOW-COLON?  ELSE  LatestWord2Hash THEN
  \ a colon should be added on ';' only
;

EXPORT

WARNING @ WARNING 0!

: ;
    POSTPONE ;
    LatestWord2Hash
    ( ���� ���� NONAME, �� ����������� �����, ������� ��� ����
      - �������� �������. )
    FALSE TO NOW-COLON?
; IMMEDIATE

: : ( C: "<spaces>name" -- colon-sys ) \ 94
  TRUE TO NOW-COLON?
  :
; \ ';' ������� ��� LatestWord2Hash (!!!)


\ �������� ���-��������� (exth) ��� �����-����������� ��������:

..: AT-WORDLIST-CREATING DUP update-wlhash ;..

WARNING !

    [DEFINED] SHEADER1                          [IF]
    ' SHEADER(SWL) TO SHEADER                   [ELSE]
    .( need a later version of SPF4 ) CR ABORT  [THEN]

 0SWL  \ ����.��

    [DEFINED] SEARCH-WORDLIST1                  [IF]
    ' QuickSWL TO SEARCH-WORDLIST               [ELSE]
    .( need a later version of SPF4 ) CR ABORT  [THEN]

;MODULE