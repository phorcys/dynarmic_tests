/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000100000000000000010"
}
*/
// Test: SLI Vd.4S, Vn.4S, #amount - Shift Left and Insert
// Shifts left and inserts into destination

.text
.global _start
_start:
    mov w0, #1
    dup v0.4s, w0
    mov w1, #1
    dup v1.4s, w1
    
    // SLI: shift left and insert
    // Insert shifted bits, keep original bits
    sli v0.4s, v1.4s, #4
    // Result: 1 | (1 << 4) = 17
    
    brk #0
