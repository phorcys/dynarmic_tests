/* CONFIG
{
  "Match": "All",
  "Q0": "0x000000000000002A000000000000002A"
}
*/
// Test: DUP Vd.2D, Xn - Duplicate general register to vector
// Duplicates a scalar value to all elements of a vector

.text
.global _start
_start:
    mov x0, #42
    
    // DUP: duplicate X0 to both 64-bit elements
    dup v0.2d, x0
    
    // V0 = [42, 42] (both 64-bit elements)

    brk #0
