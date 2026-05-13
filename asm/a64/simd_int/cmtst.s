/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: CMTST Vd.4S, Vn.4S, Vm.4S - Compare bitwise Test bits

.text
.global _start
_start:
    // v0.4s = [0x12345678, 0x00000000, 0xFFFFFFFF, 0x80000000]
    mov w0, #0x5678
    movk w0, #0x1234, lsl #16
    mov v0.s[0], w0
    mov v0.s[1], wzr
    mov w1, #0
    movk w1, #0xFFFF, lsl #16
    movk w1, #0xFFFF
    mov v0.s[2], w1
    mov w1, #0
    movk w1, #0x8000, lsl #16
    mov v0.s[3], w1
    
    // v1.4s = [0x0000FF00, 0x00000001, 0x00000000, 0x00000001]
    mov w0, #0xFF00
    mov v1.s[0], w0
    mov w0, #1
    mov v1.s[1], w0
    mov v1.s[2], wzr
    mov v1.s[3], w0
    
    // CMTST: bitwise AND, if non-zero then all 1s, else all 0s
    cmtst v0.4s, v0.4s, v1.4s
    
    brk #0
