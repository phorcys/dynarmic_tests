/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// NGCS basic

.text
.global _start
_start:
    mov x0, #0
    msr nzcv, xzr         // clear flags
    ngcs x0, x0           // 0 - 0 - 1 = -1, sets flags
    brk #0
