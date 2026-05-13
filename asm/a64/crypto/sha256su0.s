/* CONFIG
{
  "Match": "All",
  "Q0": "0x2792b01b035569bef5787789d8131b44"
}
*/
// Test: SHA256SU0 Vd.4S, Vn.4S - SHA256 schedule update 0

.text
.global _start
_start:
    // v0 = [0x12345678, 0x9ABCDEF0, 0x13579BDF, 0x2468ACE0]
    mov w0, #0x5678
    movk w0, #0x1234, lsl #16
    mov w1, #0xDEF0
    movk w1, #0x9ABC, lsl #16
    mov w2, #0x9BDF
    movk w2, #0x1357, lsl #16
    mov w3, #0xACE0
    movk w3, #0x2468, lsl #16
    
    mov v0.s[0], w0
    mov v0.s[1], w1
    mov v0.s[2], w2
    mov v0.s[3], w3
    
    // v1 = [0x87654321, 0xFEDCBA98, 0x7531DF9B, 0x0864CAE2]
    mov w0, #0x4321
    movk w0, #0x8765, lsl #16
    mov w1, #0xBA98
    movk w1, #0xFEDC, lsl #16
    mov w2, #0xDF9B
    movk w2, #0x7531, lsl #16
    mov w3, #0xCAE2
    movk w3, #0x0864, lsl #16
    
    mov v1.s[0], w0
    mov v1.s[1], w1
    mov v1.s[2], w2
    mov v1.s[3], w3
    
    sha256su0 v0.4s, v1.4s
    
    brk #0