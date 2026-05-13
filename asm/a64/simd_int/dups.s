/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000002A0000002A0000002A0000002A"
}
*/
// Test: DUP Vd.4S, Wn - Duplicate 32-bit general register to vector
// Duplicates a 32-bit scalar value to all elements of a vector

.text
.global _start
_start:
    mov w0, #42
    
    // DUP: duplicate W0 to all 32-bit elements
    dup v0.4s, w0
    
    // V0 = [42, 42, 42, 42] (all 32-bit elements)

    brk #0
