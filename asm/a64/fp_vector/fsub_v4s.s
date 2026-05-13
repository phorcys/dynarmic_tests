/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40400000400000004040000040000000",
    "Q1": "0x40A000004080000040A0000040800000",
    "Q2": "0xC0000000C0000000C0000000C0000000"
  }
}
*/
// Test: FSUB Vd.4S - vector subtract (4x single precision)
// V0.4S = [2.0, 3.0, 2.0, 3.0]
// V1.4S = [4.0, 5.0, 4.0, 5.0]
// V2.4S = V0 - V1 = [-2.0, -2.0, -2.0, -2.0]
// 2.0 = 0x40000000, 3.0 = 0x40400000
// -2.0 = 0xC0000000

.text
.global _start
_start:
    // Load V0 with [2.0, 3.0, 2.0, 3.0]
    mov x0, #0x0000
    movk x0, #0x4000, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x4040, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0
    
    // Load V1 with [4.0, 5.0, 4.0, 5.0]
    mov x1, #0x0000
    movk x1, #0x4080, lsl #16
    movk x1, #0x0000, lsl #32
    movk x1, #0x40A0, lsl #48
    mov v1.d[0], x1
    mov v1.d[1], x1
    
    // Vector subtract
    fsub v2.4s, v0.4s, v1.4s
    
    brk #0
