WINAPI: GetVersionExA KERNEL32.DLL

1 CONSTANT VER_PLATFORM_WIN32_WINDOWS
2 CONSTANT VER_PLATFORM_WIN32_NT


: WinNT? ( -- flag )
  148 HERE !
  HERE GetVersionExA 0<>
  HERE 4 CELLS + @ VER_PLATFORM_WIN32_NT = AND
;