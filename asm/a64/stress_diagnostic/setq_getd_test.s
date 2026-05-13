/* CONFIG
{
  "Match": "All",
  "Q2": "0x00000000000000000000000000000080",
  "ExpectedRegData": {
    "X0": "0x0000000000000080"
  }
}
*/
// Test: Simple vector store/load test
// This tests SetQ followed by GetD

.text
.global _start
_start:
    // Load 0x80 into V2 using mov instructions
    mov w1, #128
    mov v2.b[0], w1
    
    // Now read V2.d[0] - should get 0x80
    mov x0, v2.d[0]
    
    brk #0
