/* CONFIG
{
  "RegData": {
    "X0": "0xF00000000000000F"
  }
}
*/
// RBIT reverse bits

.text
.global _start
_start:
    mov x0, #0xF000000000000000
    movk x0, #0x000F
    rbit x0, x0           // reverse all bits
    brk #0
