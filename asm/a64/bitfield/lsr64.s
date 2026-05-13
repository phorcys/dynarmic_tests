/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000002"
  }
}
*/
// Test: LSR - Logical Shift Right (64-bit)

.text
.global _start
_start:
    // 0x8000000000000000 >> 63 = 1
    mov x0, #1
    lsl x0, x0, #63
    lsr x0, x0, #63
    
    // 0x8000000000000000 >> 62 = 2
    mov x1, #1
    lsl x1, x1, #63
    lsr x1, x1, #62

    brk #0
