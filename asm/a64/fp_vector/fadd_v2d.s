/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40080000000000004000000000000000",
    "Q1": "0x40140000000000004010000000000000",
    "Q2": "0x40200000000000004018000000000000"
  }
}
*/
// Test: FADD Vd.2D - vector add (2x double precision)
// V0.2D = [2.0, 3.0]
// V1.2D = [4.0, 5.0]
// V2.2D = V0 + V1 = [6.0, 8.0]
// 2.0 = 0x4000000000000000, 3.0 = 0x4008000000000000
// 4.0 = 0x4010000000000000, 5.0 = 0x4014000000000000
// 6.0 = 0x4018000000000000, 8.0 = 0x4020000000000000

.text
.global _start
_start:
    // Load V0 with [2.0, 3.0]
    // 2.0 = 0x4000000000000000
    mov x0, #0x0000
    movk x0, #0x0000, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x4000, lsl #48
    mov v0.d[0], x0
    // 3.0 = 0x4008000000000000
    mov x0, #0x0000
    movk x0, #0x0000, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x4008, lsl #48
    mov v0.d[1], x0
    
    // Load V1 with [4.0, 5.0]
    // 4.0 = 0x4010000000000000
    mov x1, #0x0000
    movk x1, #0x0000, lsl #16
    movk x1, #0x0000, lsl #32
    movk x1, #0x4010, lsl #48
    mov v1.d[0], x1
    // 5.0 = 0x4014000000000000
    mov x1, #0x0000
    movk x1, #0x0000, lsl #16
    movk x1, #0x0000, lsl #32
    movk x1, #0x4014, lsl #48
    mov v1.d[1], x1
    
    // Vector add
    fadd v2.2d, v0.2d, v1.2d
    
    brk #0