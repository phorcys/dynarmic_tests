/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF8"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0x78
    sbfx x0, x0, #0, #5  // bit 4 is set, so sign extend
    brk #0

