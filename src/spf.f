\ $Id$

419 CONSTANT SPF-KERNEL-VERSION

WARNING 0! \ ����� �� ���� ��������� isn't unique

: _FLIT-CODE10 ;
: _FLIT-CODE8 ;

\ S" lib\ext\disasm.f"             INCLUDED

WARNING 0! 

: PARSE-NAME NextWord ;
: UMIN 2DUP U< IF DROP EXIT THEN NIP ;

S" lib/ext/spf-asm.f"            INCLUDED
S" lib/include/tools.f"          INCLUDED
S" src/spf_compileoptions.f"     INCLUDED

ALSO ASSEMBLER DEFINITIONS
PREVIOUS DEFINITIONS

: CS-DUP 2DUP ;

C" M_WL" FIND NIP 0=
[IF] : M_WL  CS-DUP POSTPONE WHILE ; IMMEDIATE
[THEN]

: CASE 
  CSP @ SP@ CSP ! ; IMMEDIATE

: ?OF 
  POSTPONE IF POSTPONE DROP ; IMMEDIATE

: OF 
  POSTPONE OVER POSTPONE = POSTPONE ?OF ; IMMEDIATE

: ENDOF 
  POSTPONE ELSE ; IMMEDIATE

: DUPENDCASE
  BEGIN SP@ CSP @ <> WHILE POSTPONE THEN REPEAT
  CSP ! ; IMMEDIATE

: ENDCASE 
  POSTPONE DROP   POSTPONE DUPENDCASE 
; IMMEDIATE

C" LAST-HERE" FIND NIP 0= VALUE INLINEVAR


: ," ( addr u -- )
    DUP C, CHARS HERE OVER ALLOT
    SWAP CMOVE 0 C, ;

512 1024 * TO IMAGE-SIZE
0x8050000 CONSTANT IMAGE-START 

0 VALUE .forth
0 VALUE .forth#

S" src/spf_date.f"                INCLUDED
S" src/spf_xmlhelp.f"             INCLUDED
S" src/tc_spf.F"                  INCLUDED

WARNING 0! \ ����� �� ���� ��������� isn't unique

\ ==============================================================
\ ������ ��������� ������ ����-�������
\ � ������ ������� CALL ������������ �������������.
\ �������� �� ������������ �� ����� - ����� �� �����
\ ��������� ����� �������������� ��� fixups.


HERE  DUP HEX .( Base address of the image 0x) U.
TARGET-POSIX [IF]
TO .forth
[ELSE]
HERE TC-CALL,
[THEN]

\ ==============================================================
\ �������� �������������� ����� �����,
\ ����������� �� ������������ �������
0x20 TO MM_SIZE
S" src/spf_defkern.f"                INCLUDED
S" src/spf_forthproc.f"              INCLUDED
S" src/spf_floatkern.f"              INCLUDED
S" src/spf_forthproc_hl.f"           INCLUDED

\ ==============================================================
\ �������� ������ ������� Win32 � ������
\ ������� Windows, ������������ ����� SP-Forth

\ �������� ������ ������� ������������ ���������
\ � ��������� ��

TARGET-POSIX [IF]
S" src/posix/api.f"                  INCLUDED
S" src/posix/dl.f"                   INCLUDED
S" src/posix/const.f"                INCLUDED
[ELSE]
S" src/win/spf_win_api.f"            INCLUDED
S" src/win/spf_win_proc.f"           INCLUDED
S" src/win/spf_win_const.f"          INCLUDED
[THEN]

\ ==============================================================
\ ���������� �������

TARGET-POSIX [IF]
S" src/posix/memory.f"               INCLUDED
[ELSE]
S" src/win/spf_win_memory.f"         INCLUDED
[THEN]

\ ==============================================================
\ ����������������� ��������� ���������� (��.����� init)

S" src/spf_except.f"                 INCLUDED
TARGET-POSIX [IF]
S" src/posix/except.f"               INCLUDED
[ELSE]
S" src/win/spf_win_except.f"         INCLUDED
[THEN]

\ ==============================================================
\ �������� � ���������� ����-����� (OC-���������)

TARGET-POSIX [IF]
S" src/posix/io.f"                   INCLUDED
S" src/posix/con_io.f"               INCLUDED
S" src/spf_con_io.f"                 INCLUDED
[ELSE]
S" src\win\spf_win_io.f"             INCLUDED
S" src\win\spf_win_conv.f"           INCLUDED
S" src\win\spf_win_con_io.f"         INCLUDED
S" src\spf_con_io.f"                 INCLUDED
[THEN]

\ ==============================================================
\ ������ �����
\ ��� ������.

S" src/spf_print.f"                  INCLUDED
S" src/spf_module.f"                 INCLUDED

\ ==============================================================
\ ������ ��������� ������ ����-��������
S" src/compiler/spf_parser.f"        INCLUDED
S" src/compiler/spf_read_source.f"   INCLUDED

\ ==============================================================
\ ���������� ����� � ����� � �������.
\ �������� ��������� ������.
\ ����� ���� � ��������.
\ ������ ��������.
\ �����, �-� ������ ���������.

S" src/compiler/spf_nonopt.f"        INCLUDED
S" src/compiler/spf_compile0.f"      INCLUDED
\  �����������������-�����������
TRUE TO INLINEVAR

BUILD-OPTIMIZER [IF]
S" src/macroopt.f"                   INCLUDED
[ELSE]
S" src/noopt.f"                      INCLUDED
[THEN]
M\ ' DROP ' DTST TC-VECT!

S" src/compiler/spf_compile.f"       INCLUDED
S" src/compiler/spf_wordlist.f"      INCLUDED
S" src/compiler/spf_find.f"          INCLUDED
S" src/compiler/spf_words.f"         INCLUDED

\ ==============================================================
\ ���������� �������� �������.
\ ��������� ������.
\ ������������ �����.
\ �������� ��������.
\ ���������� �����������.
\ ���������� ����������� ��������.
\ ������ � ��������

S" src/compiler/spf_error.f"         INCLUDED
S" src/compiler/spf_translate.f"     INCLUDED
S" src/compiler/spf_defwords.f"      INCLUDED
S" src/compiler/spf_immed_transl.f"  INCLUDED
S" src/compiler/spf_immed_lit.f"     INCLUDED
S" src/compiler/spf_literal.f"       INCLUDED
S" src/compiler/spf_immed_control.f" INCLUDED
S" src/compiler/spf_immed_loop.f"    INCLUDED
S" src/compiler/spf_modules.f"       INCLUDED
S" src/compiler/spf_inline.f"        INCLUDED

\ ==============================================================
\ ��������� (environment).
\ ������������ ����� ��� Windows.
\ ���������������.
\ CGI

TARGET-POSIX [IF]
S" src/posix/envir.f"                INCLUDED
S" src/posix/defwords.f"             INCLUDED
S" src/posix/mtask.f"                INCLUDED
S" src/win/spf_win_cgi.f"            INCLUDED
[ELSE]
S" src\win\spf_win_envir.f"          INCLUDED
S" src\win\spf_win_defwords.f"       INCLUDED
S" src\win\spf_win_mtask.f"          INCLUDED
S" src\win\spf_win_cgi.f"            INCLUDED

\ ���������� ������� � exe-�����.

S" src\win\spf_pe_save.f"            INCLUDED
: DONE 
  CR ." DONE"
  S" src/done.f" INCLUDED
;
[THEN]

\ ==============================================================
\ ������������� ����������, startup
S" src/spf_init.f"                   INCLUDED

TARGET-POSIX [IF]
\ ==============================================================
\ ���������� ������� � exe-�����.
S" src/posix/save.f"                 INCLUDED
[THEN]

\ ==============================================================

CR .( Dummy B, B@ B! and /CHAR )
: B, C, ; : B@ C@ ; : B! C! ; : /CHAR 1 ;

CR .( =============================================================)
CR .( Done. Saving the system.)
CR .( =============================================================)
CR

TC-LATEST-> FORTH-WORDLIST
HERE ' (DP) TC-ADDR!

TARGET-POSIX [IF]

\ ���������� � ����������� ������ ������� NON-OPT-WL
' NON-OPT-WL EXECUTE DUP >VIRT! CELL+ >VIRT!
' NON-OPT-WL EXECUTE ' NON-OPT-WL TC-VECT!

\ ���������� � ������������ ������ ������� FORTH-WORDLIST
' FORTH-WORDLIST EXECUTE DUP >VIRT! CELL - >VIRT!
' FORTH-WORDLIST EXECUTE ' FORTH-WORDLIST TC-VECT!

HERE .forth - TO .forth#

ONLY DEFINITIONS

S" src/xsave.f" 		  INCLUDED
S" src/spf4.o" XSAVE

[ELSE]

TC-WINAPLINK @ ' WINAPLINK TC-ADDR!

CR  
\ HERE U.
\ DUP  HERE OVER - S" spf.bin" R/W CREATE-FILE THROW WRITE-FILE THROW

\ ���������� "DONE" � ��������� ������
S"  DONE " GetCommandLineA ASCIIZ> S"  " SEARCH 2DROP SWAP 1+ MOVE

\ �� ����� - token ����� INIT ������� �������, ��������� � ���
\ ���� ����� ��� ���� ���� ��������� � spf37x.exe ����������� ����� DONE,
\ ����������� �� � ��������� ������

CREATE-XML-HELP
[IF]
FINISH-XMLHELP
[THEN]

EXECUTE
[THEN]

