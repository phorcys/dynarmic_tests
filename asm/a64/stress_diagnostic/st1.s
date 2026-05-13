/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000200000001",
  "X1": "0x0000000400000003"
}
*/
// Test: ST1 {Vt.4S}, [Xn] - Store single 128-bit register to memory

.text
.global _start
_start:
    sub sp, sp, #32
    
    // Setup: create vector with 4 words
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    
    // Build vector v0.4s = [1, 2, 3, 4]
    ins v0.s[0], w0
    ins v0.s[1], w1
    ins v0.s[2], w2
    ins v0.s[3], w3
    
    // ST1: store single 128-bit register
    st1 {v0.4s}, [sp]
    
    // Load back to verify
    ldp x0, x1, [sp]
    
    brk #0