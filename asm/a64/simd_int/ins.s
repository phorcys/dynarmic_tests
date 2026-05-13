/* CONFIG
{
  "Match": "All",
  "Q0": "0x000000000000002A0000000000000000"
}
*/
// Test: INS Vd.B[index], Wn - Insert scalar into vector element
// Inserts a scalar value into a specific vector element

.text
.global _start
_start:
    movi v0.16b, #0
    mov w0, #42
    
    // INS: insert W0 byte into V0 element 0
    ins v0.b[0], w0
    
    // V0.b[0] = 42

    brk #0
