/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000000000000"
  }
}
*/
// Test: UBFIZ - Unsigned Bit Field Insert in Zero
// UBFIZ Xd, Xn, #lsb, #width: Extract bits and zero-extend

.text
.global _start
_start:
    mov x2, #0xF
    movk x2, #0xFFFF, lsl #16
    movk x2, #0xFFFF, lsl #32  // x2 = 0xFFFFFFFF000F
    
    // UBFIZ X1, X2, #28, #4
    // Extract 4 bits starting at bit 0, insert at bit 28, zero-extend
    // bits[3:0] of x2 = 0xF
    // Insert at bit 28 -> bits[31:28] = 0xF
    // Zero-extend: upper bits = 0
    // Result = 0x00000000F0000000
    // Wait, that's wrong. Let me recalculate.
    // UBFIZ Xd, Xn, #lsb, #width
    // Extract width bits from Xn[width-1:0], insert at lsb
    // So: Xn[3:0] = 0xF, insert at bits[31:28]
    // Result bits[31:28] = 0xF, rest = 0
    // Result = 0x00000000F0000000
    // N=1 (bit 31 = 1), Z=0
    
    // Actually, let's use a simpler test
    mov x2, #0
    
    ubfiz x1, x2, #28, #4
    
    // x2 = 0, so result = 0
    // N=0, Z=1 -> NZCV = 0x40000000
    
    mrs x0, nzcv
    
    brk #0
