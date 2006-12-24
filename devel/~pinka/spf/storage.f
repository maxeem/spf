\ 23.Dec.2006 Sat 16:08, ruvim@forth.org.ru
\ $Id$
( ��������� ����������� �������� ��� SPF4.
  ������������ ���� ��������� ��������� �� ���������� [storage-core.f]
  � ����� ��������� ����������:
    - ������� ������ ���� ��� ����������,
    - ������ ���� �� ���������, ��� ����� ��������� ��������,
    - ������ �������� [������� ����, VOC-LIST], �� ���� �������� � ���������.

  ������� ��������� ������� ����� ���������, �����
  SET-CURRENT ������������� ������� � ���������,
  � ������� ������������� �������.

  ������ ������������� ����� �������� ����
  TEMP-WORDLIST - ������� ��������� ��������� � � ��� �������,
  � FREE-WORDLIST - ������������� ���������, � ������� ���������� �������.

  ������ ���������� ����� UNUSED, ����������� ������� ���������, ������� 
  ��� ������������� lib/include/core-ext.f ��� ������ ���� ���������� ������,
  �.�. � ��� UNUSED ���� ������������.

  ����, �� ������������� �����, ������������ � quick-swl*.f !!!
)

REQUIRE Included ~pinka\lib\ext\requ.f
REQUIRE REPLACE-WORD lib\ext\patch.f


WARNING @  WARNING 0!

: AT-SAVING-BEFORE ... ;
: AT-SAVING-AFTER ... ;

: SAVE ( addr u -- )
  AT-SAVING-BEFORE
  SAVE
  AT-SAVING-AFTER
;
\ �.�. ���� �������� ������� ��������� ����� �����������.


' DP
USER DP ( -- addr ) \ ����������, ���������� HERE �������� ������

DUP EXECUTE @ DP !  ' DP SWAP REPLACE-WORD
\ �������� ������ DP, ����� �� �������������� ��� ������������� �����

USER STORAGE \ ������� ���������. 
              \ ��� ����� ���������� ������ ����� �������������.

S" storage-core.f" Included

\ ���������� ����������� ���������:

..: AT-FORMATING ( -- )
  ( ALIGN) HERE STORAGE-EXTRA !
  0 ,       \ 0, current wid
  0 ,       \ 1, extra
  HERE 0 ,  \ 2, default wid
  0 ,       \ 3, voc-list
  WORDLIST
  DUP STORAGE-EXTRA @ ! \ to current
  SWAP !                \ to default
;..

..: AT-DISMOUNTING ( -- )
  CURRENT @  STORAGE-EXTRA @  !  CURRENT 0!
;..

..: AT-MOUNTING ( -- )
  STORAGE-EXTRA @  @ CURRENT !
;..

: DEFAULT-WORDLIST ( -- wid )
  STORAGE-EXTRA @  CELL+ CELL+ @
;

VOC-LIST @ ' VOC-LIST 
( old-voc-list@  'voc-list )

CREATE _VOC-LIST-EMPTY 0 , 
\ ���� ���-�� ������� ���������� ������� ��� ����������� ���������.

: VOC-LIST ( -- addr )
  STORAGE-ID IF STORAGE-EXTRA @ 3 CELLS + EXIT THEN _VOC-LIST-EMPTY
;
' VOC-LIST SWAP REPLACE-WORD

: STORAGE-EXTRA ( -- a ) \ ��������� ������
  STORAGE-EXTRA @ CELL+
;

( old-voc-list@ )
ALIGN HERE IMAGE-SIZE HERE IMAGE-BASE - - ( addr u ) \ see  lib/include/core-ext.f
FORMAT
  DUP MOUNT \ (!!!)
  FORTH-WORDLIST SET-CURRENT
CONSTANT FORTH-STORAGE  \ ������� ��������� ����-�������

( old-voc-list@ ) VOC-LIST !  \ ������ �������� �������� ���������

..: AT-PROCESS-STARTING  FORTH-STORAGE MOUNT ;..

..: AT-SAVING-BEFORE FLUSH-STORAGE ;..


\ ==================================================

Include enum-vocs.f  \ ����� ������������ ����� VOC-LIST

\ ========
\ ����� ��� SET-CURRENT ������� ����������� � ���������, � ������� ���������� �������,
\ ���������� ����� ������� ���� ���� ���������.

Require WID-EXTRA  wid-extra.f
\ ��� ������������ � WORDLIST � ������ ������ VOC-LIST

MODULE: WidStorageSupport

: MAKE-EXTR ( wid -- )
  ALIGN HERE STORAGE-ID , 0 ,
  SWAP WID-EXTRA !
;

..: AT-WORDLIST-CREATING DUP MAKE-EXTR ;..

EXPORT

: WL-STORAGE ( wid -- h-storage )
  WID-EXTRA @ @
;
: WID-EXTRA ( wid -- addr )
  WID-EXTRA @ CELL+
;

' MAKE-EXTR ENUM-VOCS  \ ���������� STORAGE-ID ��� ������������ ��������

;MODULE

\ �������������� ��� �����, ���������� �� SET-CURRENT
\ (�.�. ����������� ����� �����������, � ��������� ������ ���������� ����� ������������)

' SET-CURRENT
: SET-CURRENT ( wid -- )
  DUP WL-STORAGE MOUNT  CURRENT !
;
' SET-CURRENT SWAP REPLACE-WORD

' DEFINITIONS
: DEFINITIONS ( -- ) \ 94 SEARCH
  CONTEXT @ SET-CURRENT
;
' DEFINITIONS  SWAP REPLACE-WORD

' MODULE:
: MODULE: ( "name" -- old-current )
  >IN @ 
  ['] ' CATCH
  IF >IN ! VOCABULARY LATEST NAME> ELSE NIP THEN
  GET-CURRENT SWAP ALSO EXECUTE DEFINITIONS
;
' MODULE: SWAP REPLACE-WORD


\ =====
\ ��������� ��������� � �������

: AT-STORAGE-DELETING ( -- ) ... ;

: NEW-STORAGE ( size -- h )
  DUP ALLOCATE THROW SWAP 
  2DUP ERASE FORMAT
;
: DEL-STORAGE ( h -- )
  PUSH-MOUNT AT-STORAGE-DELETING POP-MOUNT FREE THROW
;

: TEMP-WORDLIST ( -- wid )
\ ������� ��������� ��������� � ������� ���� (����)
\ � � ��� �������
  WL_SIZE NEW-STORAGE PUSH-MOUNT
  DEFAULT-WORDLIST  POP-MOUNT DROP
;
: FREE-WORDLIST ( wid -- )
  WL-STORAGE DEL-STORAGE
;

WARNING !