/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FF0F"
  }
}
*/
// Test: BFC - Bit Field Clear

.text
.global _start
_start:
    mov x0, #0xFFFF
    
    // BFC: clear bits [7:4]
    bfc x0, #4, #4

    brk #0
