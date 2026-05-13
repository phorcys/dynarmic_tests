/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x4100000040C000004080000040000000",
    "Q1": "0x40C00000404000004080000040800000",
    "Q2": "0xFFFFFFFFFFFFFFFF0000000000000000"
  }
}
*/
// Test: FCMGT Vd.4S, Vn.4S, Vm.4S - compare greater than

.text
.global _start
_start:
    // Load Q0 with [2.0, 4.0, 6.0, 8.0]
    mov w0, #0x0000
    movk w0, #0x4000, lsl #16  // 2.0
    mov v0.s[0], w0
    
    mov w1, #0x0000
    movk w1, #0x4080, lsl #16  // 4.0
    mov v0.s[1], w1
    
    mov w2, #0x0000
    movk w2, #0x40C0, lsl #16  // 6.0
    mov v0.s[2], w2
    
    mov w3, #0x0000
    movk w3, #0x4100, lsl #16  // 8.0
    mov v0.s[3], w3
    
    // Load Q1 with [4.0, 4.0, 3.0, 6.0]
    mov w4, #0x0000
    movk w4, #0x4080, lsl #16  // 4.0
    mov v1.s[0], w4
    mov v1.s[1], w4
    
    mov w5, #0x0000
    movk w5, #0x4040, lsl #16  // 3.0
    mov v1.s[2], w5
    
    mov w6, #0x0000
    movk w6, #0x40C0, lsl #16  // 6.0
    mov v1.s[3], w6
    
    // FCMGT: compare Q0 > Q1
    // [2.0, 4.0, 6.0, 8.0] > [4.0, 4.0, 3.0, 6.0] = [0, 0, 1, 1]
    fcmgt v2.4s, v0.4s, v1.4s

    brk #0
