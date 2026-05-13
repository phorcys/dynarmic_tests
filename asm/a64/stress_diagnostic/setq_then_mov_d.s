/* CONFIG
{
  "Match": "All",
  "ExpectedRegData": {
    "X0": "0x0000000000000080"
  }
}
*/
// Test: Simple case - set Q then read D
// This tests the IR optimization path

.text
.global _start
_start:
    // Set V2.b[0] = 128 using INS (which uses SetQ)
    mov w1, #128
    mov v2.b[0], w1
    
    // Read V2.d[0] using UMOV with d element (should use GetQ then VectorGetElement64)
    mov x0, v2.d[0]
    
    brk #0
