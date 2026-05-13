/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// NGC basic

.text
.global _start
_start:
    mov x0, #0
    msr nzcv, xzr         // clear flags (C=0)
    ngc x0, x0            // 0 - 0 - !C = 0 - 0 - 1 = -1
    brk #0
