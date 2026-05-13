/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000000000000",
    "X2": "0x0000000040000000"
  }
}
*/
// Edge case test: adds_zero

.text
.global _start
_start:

    mov w0, #0
    adds w1, w0, #0   // 0 + 0 = 0
    mrs x2, nzcv      // N=0, Z=1, C=0, V=0 => NZCV=0x40000000


    brk #0
