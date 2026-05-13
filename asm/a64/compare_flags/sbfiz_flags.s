/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0xFFFFFFFFF0000000"
  }
}
*/
// Test: SBFIZ - Signed Bit Field Insert in Zero
// SBFIZ Xd, Xn, #lsb, #width: Extract bits and sign-extend

.text
.global _start
_start:
    mov x2, #0xF
    movk x2, #0xFFFF, lsl #16
    movk x2, #0xFFFF, lsl #32  // x2 = 0xFFFFFFFF000F
    
    // SBFIZ X1, X2, #28, #4
    // Extract 4 bits starting at bit 0, insert at bit 28, sign-extend
    // bits[3:0] of x2 = 0xF (all 1s)
    // Insert at bit 28 -> bits[31:28] = 0xF
    // Sign-extend: bit 31 = 1, so all upper bits = 1
    // Result = 0xFFFFFFFFF0000000
    // N=0, Z=1 (wait, result is not zero)
    // Actually result is non-zero and bit 63 is 1 (sign extended)
    // But MRS NZCV gives current flags, not the result
    // SBFIZ doesn't set flags, so NZCV is from previous op
    // Let me check what flags are set
    
    sbfiz x1, x2, #28, #4
    
    mrs x0, nzcv
    
    brk #0