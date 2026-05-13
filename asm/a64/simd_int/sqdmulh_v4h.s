/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q1": "0x00000000000000000000000000000000"
  }
}
*/
// Test: SQDMULH Vd.4H, Vn.4H, Vm.4H - saturating doubling multiply high

.text
.global _start
_start:
    // Load Q0 with [1, 1, 1, 1] as 16-bit elements
    mov w0, #1
    dup v0.4h, w0
    
    // Load Q1 with [2, 2, 2, 2]
    mov w1, #2
    dup v1.4h, w1
    
    // SQDMULH: Q1 = (Q0 * Q1 * 2) >> 16, saturating
    // (1 * 2 * 2) >> 16 = 4 >> 16 = 0
    sqdmulh v1.4h, v0.4h, v1.4h

    brk #0