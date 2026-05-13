/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000002",
    "X7": "0x8000000000000000",
    "X9": "0xFFFFFFFFFFFFFFFF",
    "X11": "0x8000000000000000"
  }
}
*/
// Variable-shift modulo-width boundaries for 64-bit shifts and rotates.

.text
.global _start
_start:
    mov x0, #1
    mov x1, #64
    lslv x2, x0, x1            // 64 mod 64 = 0

    mov x3, #1
    mov x4, #65
    lslv x3, x3, x4            // 65 mod 64 = 1

    mov x5, #1
    lsl x5, x5, #63
    mov x6, #64
    lsrv x7, x5, x6            // 64 mod 64 = 0

    mov x8, #-2
    mov x10, #65
    asrv x9, x8, x10           // -2 >> 1 = -1

    mov x11, #1
    rorv x11, x11, x4          // rotate right by 1

    brk #0
