/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40400000408000004040000040800000",
    "Q1": "0xC0400000C0800000C0400000C0800000"
  }
}
*/
// Test: FNEG Vd.4S - vector negate (4x single precision)
// V0.4S = [4.0, 3.0, 4.0, 3.0]
// V1.4S = -V0.4S = [-4.0, -3.0, -4.0, -3.0]
// 3.0 = 0x40400000, 4.0 = 0x40800000
// -3.0 = 0xC0400000, -4.0 = 0xC0800000

.text
.global _start
_start:
    // Load V0 with [4.0, 3.0, 4.0, 3.0]
    // Low 64 bits: [4.0, 3.0] = 0x40400000_40800000
    // bits [31:0] = 4.0 = 0x40800000
    // bits [63:32] = 3.0 = 0x40400000
    mov x0, #0x0000
    movk x0, #0x4080, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x4040, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0
    
    // Vector negate
    fneg v1.4s, v0.4s
    
    brk #0
