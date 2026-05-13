/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// SBFIZ - Signed Bit Field Insert Zero

.text
.global _start
_start:
    mov x0, #0
    sbfiz x0, x0, #0, #8   // insert 8 bits of x0 (zeros) at bit 0
    brk #0
