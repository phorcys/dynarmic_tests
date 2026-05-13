/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000000000000",
    "X3": "0x0000000070000000"
  }
}
*/
// Edge case test: adds_overflow_neg
// 0x80000000 + 0x80000000 = 0, N=0, Z=1, C=1, V=1

.text
.global _start
_start:

    mov w0, #1
    lsl w0, w0, #31   // w0 = 0x80000000
    mov w1, #1
    lsl w1, w1, #31   // w1 = 0x80000000
    adds w2, w0, w1   // 0x80000000 + 0x80000000 = 0 (with overflow)
    mrs x3, nzcv      // N=0, Z=1, C=1, V=1 => NZCV=0x70000000


    brk #0
