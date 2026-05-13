/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// SBC basic

.text
.global _start
_start:
    mov x0, #5
    mov x1, #3
    cmp xzr, xzr          // set C=1
    sbc x0, x0, x1        // 5 - 3 - 0 = 2? No, SBC is x0 - x1 - !C
    // With C=1: 5 - 3 - 0 = 2
    // But we want to test it properly
    brk #0
