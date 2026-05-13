/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x000000007FFFFFFF",
    "X2": "0x0000000030000000"
  }
}
*/
// Edge case test: subs_overflow

.text
.global _start
_start:

    mov w0, #1
    lsl w0, w0, #31   // w0 = 0x80000000
    subs w1, w0, #1   // 0x80000000 - 1 = 0x7FFFFFFF
    mrs x2, nzcv      // N=0, Z=0, C=1 (no borrow), V=1 => NZCV=0x30000000


    brk #0
