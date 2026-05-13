/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000000000001"
  }
}
*/
// Edge case test: mul_overflow_32

.text
.global _start
_start:

    mov w0, #0xFFFF
    movk w0, #0xFFFF, lsl #16   // w0 = 0xFFFFFFFF
    mul w1, w0, w0              // 0xFFFFFFFF * 0xFFFFFFFF = 1 (mod 2^32)


    brk #0
