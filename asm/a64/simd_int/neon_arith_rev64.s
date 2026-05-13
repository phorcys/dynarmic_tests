/* CONFIG
{
  "Match": "All",
  "VecData": {
    "V1": ["0x0000000100000002", "0x0000000300000004"]
  }
}
*/
// Test: REV64 - Reverse elements in 64-bit lanes

.text
.global _start
_start:
    // V0 = [1, 2, 3, 4] (4x 32-bit)
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    ins v0.s[0], w0
    ins v0.s[1], w1
    ins v0.s[2], w2
    ins v0.s[3], w3
    
    // REV64 V1.4S, V0.4S
    // Reverse 32-bit elements within each 64-bit lane
    // V0 = [1, 2 | 3, 4] -> V1 = [2, 1 | 4, 3]
    rev64 v1.4s, v0.4s

    brk #0
