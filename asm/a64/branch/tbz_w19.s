/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X19": "0x0000000000000109",
    "X0": "0x0000000000000001"
  }
}
*/
// Test: TBZ with W19 register (32-bit)
// W19 = 0x109 = 0b0001_0000_1001
// Bit 1 of W19 is 0, so TBZ W19, #1 should branch

.text
.global _start
_start:
    mov w19, #0x109     // W19 = 0x109, bit 1 = 0
    
    tbz w19, #1, target  // Should branch (bit 1 is 0)
    mov x0, #0          // Should be skipped
    
target:
    mov x0, #1          // x0 = 1 if branch taken

    brk #0
