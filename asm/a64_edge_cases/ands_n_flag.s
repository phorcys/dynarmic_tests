/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000080000000",
    "X3": "0x0000000080000000"
  }
}
*/
// Edge case test: ands_n_flag

.text
.global _start
_start:

    mov w0, #1
    lsl w0, w0, #31   // w0 = 0x80000000
    mov w1, #1
    lsl w1, w1, #31   // w1 = 0x80000000
    ands w2, w0, w1   // 0x80000000 & 0x80000000 = 0x80000000
    mrs x3, nzcv      // N=1, Z=0 => NZCV=0x80000000


    brk #0
