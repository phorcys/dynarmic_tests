/* CONFIG
{
  "Match": "All",
  "VecData": {
    "V2": ["0x0000000000000000", "0x0000000000000000"]
  }
}
*/
// Test: ADDHN - Add and narrow (high half)
// ADDHN Vd, Vn, Vm : Vd = narrow(high_half(Vn + Vm))
// Takes the HIGH half of each widened element

.text
.global _start
_start:
    // V0 = [0, 1, 2, 3] (4x 32-bit)
    mov w0, #0
    mov w1, #1
    mov w2, #2
    mov w3, #3
    ins v0.s[0], w0
    ins v0.s[1], w1
    ins v0.s[2], w2
    ins v0.s[3], w3
    
    // V1 = [0, 1, 2, 3]
    ins v1.s[0], w0
    ins v1.s[1], w1
    ins v1.s[2], w2
    ins v1.s[3], w3
    
    // ADDHN V2.4H, V0.4S, V1.4S
    // Add 32-bit values, take high 16 bits, narrow to 16-bit
    // [0+0, 1+1, 2+2, 3+3] = [0, 2, 4, 6]
    // High 16 bits of each 32-bit result = [0, 0, 0, 0] (all values < 65536)
    addhn v2.4h, v0.4s, v1.4s

    brk #0
