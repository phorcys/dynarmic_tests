/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000080000000",
    "X2": "0x0000000090000000"
  }
}
*/
// Edge case test: adds_overflow_pos

.text
.global _start
_start:

    mov w0, #1
    lsl w0, w0, #31
    sub w0, w0, #1    // w0 = 0x7FFFFFFF
    adds w1, w0, #1   // 0x7FFFFFFF + 1 = 0x80000000
    mrs x2, nzcv      // N=1, Z=0, C=0, V=1 => NZCV=0x90000000


    brk #0
