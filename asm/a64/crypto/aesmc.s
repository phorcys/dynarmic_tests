/* CONFIG
{
  "Match": "All",
  "Q0": "0x88ddaaffcc99eebb0055227744116633"
}
*/
// Test: AESMC Vd.16B, Vn.16B - AES mix columns
// Input: v0 = 0x00112233445566778899aabbccddeeff

.text
.global _start
_start:
    // v0 = 0x00112233445566778899aabbccddeeff
    mov x0, #0x11
    movk x0, #0x2233, lsl #16
    movk x0, #0x4455, lsl #32
    movk x0, #0x6677, lsl #48
    mov v0.d[0], x0
    
    mov x0, #0x8899
    movk x0, #0xaabb, lsl #16
    movk x0, #0xccdd, lsl #32
    movk x0, #0xeeff, lsl #48
    mov v0.d[1], x0
    
    aesmc v0.16b, v0.16b
    
    brk #0
