/* CONFIG
{
  "RegData": {
    "X0": "0x00000000F0000000"
  }
}
*/
// CCMP nzcv fallback

.text
.global _start
_start:
    mov x0, #5
    mov x1, #10
    cmp x0, x1           // N=1
    ccmp xzr, xzr, #15, ge  // condition false, use nzcv=15 (all flags)
    mrs x0, nzcv
    brk #0
