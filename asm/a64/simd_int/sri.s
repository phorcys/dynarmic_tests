/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000110000000000000011"
}
*/
// Test: SRI Vd.4S, Vn.4S, #amount - Shift Right and Insert
// Shifts right and inserts into destination

.text
.global _start
_start:
    mov w0, #16
    dup v0.4s, w0
    mov w1, #16
    dup v1.4s, w1
    
    // SRI: shift right and insert
    // Insert shifted bits, keep original bits
    sri v0.4s, v1.4s, #2
    // Result: (16 & ~mask) | (16 >> 2) = lower bits preserved + 4
    
    brk #0
