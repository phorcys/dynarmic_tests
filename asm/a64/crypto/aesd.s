/* CONFIG
{
  "Match": "All",
  "Q0": "0x7b2c9151e02ef8acf12b0970d856dde3"
}
*/
// Test: AESD Vd.16B, Vn.16B - AES single round decryption
// Input: v0 = 0x00112233445566778899aabbccddeeff
//        v1 = 0x0f0e0d0c0b0a09080706050403020100 (round key)

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
    
    // v1 = 0x0f0e0d0c0b0a09080706050403020100
    mov x0, #0x0100
    movk x0, #0x0302, lsl #16
    movk x0, #0x0504, lsl #32
    movk x0, #0x0706, lsl #48
    mov v1.d[0], x0
    
    mov x0, #0x0908
    movk x0, #0x0b0a, lsl #16
    movk x0, #0x0d0c, lsl #32
    movk x0, #0x0f0e, lsl #48
    mov v1.d[1], x0
    
    aesd v0.16b, v1.16b
    
    brk #0
