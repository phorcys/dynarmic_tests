/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// CLREX basic

.text
.global _start
_start:
    mov x0, #1
    clrex
    brk #0
