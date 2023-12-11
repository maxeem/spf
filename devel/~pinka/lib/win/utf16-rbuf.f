REQUIRE RBUF                    ~pinka/spf/rbuf.f
REQUIRE UTF8>UTF16              ~pinka/lib/win/utf16.f
REQUIRE [:                      lib/include/quotation.f

: R:UTF8>UTF16 \ Run-time ( sd.txt1 -- sd.txt2 )
  \ Only for compilation.
  \ The max size of the input string sd.txt1 is 4 KiB (otherwise, -12 "argument type mismatch" is thrown).
  \ sd.txt2 is null-terminated, and its size does not include this character (2 bytes).
  \ sd.txt2 is allocated on the return stack and is automatically freed when the containing definition returns.
  \ Local variables in the containing definition (if any) become inaccessible.
  [: DUP 4096 U> IF -12 THROW THEN  DUP 1+ 2* ;] COMPILE,
  \ NB: in the worst case utf16 takes 2x of utf8
  POSTPONE RBUF
  [: UTF8>UTF16  2DUP + 0 SWAP W! ;] COMPILE,
; IMMEDIATE

