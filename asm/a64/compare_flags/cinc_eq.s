/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// CINC when condition true

.text
.global _start
_start:
    mov x0, #1
    cmp x0, x0      // Z=1
    cinc x0, x0, eq
    brk #0
