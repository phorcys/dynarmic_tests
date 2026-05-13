/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000010000000100000001000000010",
    "Q1": "0x00000002000000020000000200000002"
  }
}
*/
// Test: USRA Vd.4S, Vn.4S, #shift - unsigned shift right and accumulate

.text
.global _start
_start:
    // Load Q0 with [16, 16, 16, 16]
    mov w0, #16
    dup v0.4s, w0
    
    // Load Q1 with [1, 1, 1, 1]
    mov w1, #1
    dup v1.4s, w1
    
    // USRA by 4: Q1 += Q0 >> 4 = 1 + 1 = 2
    usra v1.4s, v0.4s, #4

    brk #0
