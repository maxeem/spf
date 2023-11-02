\ Tools for wordlists
\ 2015-05 rvm

REQUIRE [:  lib/include/quotations.f

[UNDEFINED] 2NIP [IF]
: 2NIP ( xd2 xd1 -- xd1 ) 2SWAP 2DROP ;
[THEN]


: NAME>INTERPRET ( nt -- xt ) \ "name-to-interpret" TOOLS-EXT
  NAME>
;

: NAME>COMPILE   ( nt -- w xt ) \ "name-to-compile" TOOLS-EXT
  DUP NAME> SWAP IS-IMMEDIATE IF ['] EXECUTE ELSE ['] COMPILE, THEN
;

\ TRAVERSE-WORDLIST
\ https://forth-standard.org/standard/tools/TRAVERSE-WORDLIST

: TRAVERSE-WORDLIST ( i*x xt wid -- j*x ) \ "traverse-wordlist" TOOLS-EXT
  \ xt  ( i*x nt -- j*x flag ) \ iteration stops on FALSE
  \ NB This word is not allowed to expose the current definition or hidden definitions, if any (see "SMUDGE")
  \ https://forth-standard.org/proposals/traverse-wordlist-does-not-find-unnamed-unfinished-definitions?hideDiff#reply-487
  SWAP >R  LATEST-NAME-IN ( nt|0 )
  BEGIN DUP WHILE ( nt ) R@ OVER >R EXECUTE R> SWAP WHILE NAME>NEXT-NAME REPEAT THEN DROP RDROP
;

\ see also:
\   FOR-WORDLIST  ( wid xt -- ) \ xt ( nfa -- )
\     -- src/compiler/spf_wordlist.f (since 2007)
\   FOREACH-WORDLIST-PAIR ( i*x xt wid -- j*x ) \ xt ( i*x  xt1 d-txt-name1 -- j*x )
\     -- ~pinka/spf/compiler/native-wordlist.f

: SEARCH-WORDLIST-WITH ( i*x wid xt -- j*x nt|0 )
  \ xt ( i*x nt -- j*x flag ) \ iteration stops on TRUE
  >R LATEST-NAME-IN
  BEGIN DUP WHILE R@ OVER >R EXECUTE R> SWAP 0= WHILE NAME>NEXT-NAME REPEAT THEN RDROP
;
: FIND-WORDLIST-WITH ( i*x xt -- j*x wid|0 )
  \ Interate over word lists in the search order
  \ xt  ( i*x wid -- j*x flag ) \ iteration stops on TRUE
  >R CONTEXT BEGIN ( addr ) ( R: xt )
    DUP S-O U> WHILE >R 2R@ @ SWAP EXECUTE 0= WHILE R> CELL-
  REPEAT R> @ RDROP EXIT THEN RDROP DROP 0
;



: EQ-CHARI ( c2 c1 -- flag ) \ ASCII-case-insensitive
  OVER XOR DUP 0= IF 2DROP TRUE EXIT THEN ( c1 x )
  DUP 32 ( %100000 ) <> IF 2DROP FALSE EXIT THEN
  OR  [CHAR] a  [ CHAR z 1+ ] LITERAL  WITHIN
;
: NE-CHARI ( c2 c1 -- flag ) \ ASCII-case-insensitive
  EQ-CHARI 0=
;
: EQUALSI ( sd.txt2 sd.txt1 -- flag ) \ ASCII-case-insensitive
  ROT OVER <> IF ( a2 a1 u1 ) DROP 2DROP FALSE EXIT THEN
  DUP 0= IF DROP 2DROP TRUE EXIT THEN OVER + ( a2 a1 a1a )
  SWAP DO ( a2 )
    COUNT I C@ ( a22 c2 c1 )
    NE-CHARI IF DROP UNLOOP FALSE EXIT THEN
  LOOP DROP TRUE
;


\ FIND-NAME and FIND-NAME-IN were accepted in 2018
\ https://forth-standard.org/proposals/find-name?hideDiff#reply-174

: (FIND-NAME-IN) ( sd.name wid -- sd.name nt|0 )
  [: NAME>STRING 2OVER EQUALSI ;] SEARCH-WORDLIST-WITH
;
: FIND-NAME-IN ( sd.name wid -- nt|0 )
  (FIND-NAME-IN) NIP NIP
;
: FIND-NAME-WORDLIST ( sd.name -- nt wid | 0 0 )
  0 [: ( sd.name 0 nt -- sd.name nt|0 nt|0 ) NIP (FIND-NAME-IN) DUP ;] FIND-WORDLIST-WITH
  ( sd.name nt wid | sd.name 0 0 ) 2NIP
;
: FIND-NAME ( sd.name -- nt|0 )
  FIND-NAME-WORDLIST VOC-FOUND !
;



\ 2017-04-23
\ "SYNONYM" from TOOLS-EXT 2012

: ENROLL-NAME ( xt d-newname -- ) \ basic factor
  \ see also: ~pinka/spf/compiler/native-wordlist.f
  SHEADER LATEST-NAME NAME>C !
;
: ENROLL-SYNONYM ( d-oldname d-newname -- ) \ postfix version of SYNONYM
  2>R SFIND DUP 0= IF -321 THROW THEN ( xt -1|1 )
  SWAP 2R> ENROLL-NAME 1 = IF IMMEDIATE THEN
;
: SYNONYM ( "<spaces>newname" "<spaces>oldname" -- ) \ 2012 TOOLS EXT
  PARSE-NAME PARSE-NAME 2SWAP ENROLL-SYNONYM
;
