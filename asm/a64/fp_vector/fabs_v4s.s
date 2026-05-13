/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0xC0400000C0800000C0400000C0800000",
    "Q1": "0x40400000408000004040000040800000"
  }
}
*/
// Test: FABS Vd.4S - vector absolute value (4x single precision)
// V0.4S = [-4.0, -3.0, -4.0, -3.0]
// V1.4S = |V0.4S| = [4.0, 3.0, 4.0, 3.0]
// -3.0 = 0xC0400000, -4.0 = 0xC0800000
// 3.0 = 0x40400000, 4.0 = 0x40800000

.text
.global _start
_start:
    // Load V0 with [-4.0, -3.0, -4.0, -3.0]
    // Low 64 bits: [-4.0, -3.0] = [0xC0800000, 0xC0400000]
    // bits [31:0] = -4.0, bits [63:32] = -3.0
    mov x0, #0x0000
    movk x0, #0xC080, lsl #16   // bits [31:16]
    movk x0, #0x0000, lsl #32   // bits [47:32]
    movk x0, #0xC040, lsl #48   // bits [63:48]
    mov v0.d[0], x0
    // High 64 bits: same values
    mov v0.d[1], x0
    
    // Vector absolute value
    fabs v1.4s, v0.4s
    
    brk #0
