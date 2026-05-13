/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q1": "0x00000000000000000001000100010001"
  }
}
*/
// Test: SQRDMULH Vd.4H, Vn.4H, Vm.4H - saturating rounding doubling multiply high

.text
.global _start
_start:
    // Load Q0 with [100, 100, 100, 100] as 16-bit elements
    mov w0, #100
    dup v0.4h, w0
    
    // Load Q1 with [200, 200, 200, 200]
    mov w1, #200
    dup v1.4h, w1
    
    // SQRDMULH: Q1 = ((Q0 * Q1 * 2) + (1<<15)) >> 16, saturating
    // ((100 * 200 * 2) + 32768) >> 16 = (40000 + 32768) >> 16 = 72768 >> 16 = 1
    sqrdmulh v1.4h, v0.4h, v1.4h

    brk #0