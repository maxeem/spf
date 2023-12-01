\ 2012
\ Распределение памяти на стеке возвратов с автоматическим освобождением при выходе.
\ $Id$

\ Слово RBUF ( u -- addr u ) возвращает распределеный блок памяти.
\ Память освобождается при выходе из того слова, в котором вызвано RBUF
\ Допускается запрашивать произвольное число блоков памяти.
\ Если свободного пространства недостаточно, то произойдет аппаратное исключение STACK_OVERFLOW


: (FREE-RBUF) 
  R> RFREE
;
: RBUF ( u -- addr u ) ( R: -- i*x nest-sys )
  \ Only for compilation.
  R>
  OVER CELL+ 1- >CELLS DUP RALLOT SWAP >R  ( u r a )
  ['] (FREE-RBUF) >R
  SWAP >R
  SWAP
;
: RDROP-BUF ( -- ) ( R: i*x nest-sys -- )
  \ Only for compilation.
  R> RDROP R> RFREE >R
;

: RCARBON ( addr u -- addr2 u ) ( R: -- i*x nest-sys )
  \ Only for compilation.
  \ The character 0x0 is appended after the data block.
  R>
  OVER CHAR+ CELL+ 1- >CELLS DUP RALLOT SWAP >R  ( u r a )
  ['] (FREE-RBUF) >R
  SWAP >R ( addr u a )
  SWAP ( addr a u )
  2DUP 2>R MOVE 2R> 2DUP + 0 SWAP C!
;


: MOD-MEMORY-PAGESIZE ( u1 -- u2 )
  [ MEMORY-PAGESIZE DUP NEGATE SWAP 1- OR -1 = ] [IF] \ it's a pow of two
    [ MEMORY-PAGESIZE 1- ] LITERAL  AND
  [ELSE]
    MEMORY-PAGESIZE UMOD
  [THEN]
;

: ENSURE-ASCIIZ-R ( addr u -- addr2 u ) ( R: -- i*x nest-sys )
\ Only for compilation.
\ Если addr есть 0, то возвращается ( addr u ) без изменений;
\ если поданая строка не имеет 0 за последним символом,
\ то создается копия строки в формате ASCIIZ на стеке возвратов
\ которая автоматически освобождается при выходе из слова,
\ в котором вызвано ENSURE-ASCIIZ-R
  OVER 0= IF EXIT THEN
  2DUP +  DUP MOD-MEMORY-PAGESIZE IF
    \ NB: the next character after the string is only read
    \ if its address is not the address of the next memory page,
    \ to avoid a possible access violation error.
    C@ 0= IF EXIT THEN
  THEN
  R> -ROT RCARBON ROT >R
;

\EOF

: test
    RP@ .
  12 RBUF ( addr u )
    OVER . DUP . 2DUP + . CR
    RP@ . CR
  2DUP DUMP
  2DUP ERASE
;

  test DUMP
