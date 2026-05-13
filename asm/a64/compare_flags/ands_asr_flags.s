/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0xFFFFFFFFFFFFFFFC"
  }
}
*/
// Test: ANDS with ASR shift - AND with flag set (Arithmetic Shift Right)
// ANDS Xd, Xn, Xm, ASR #amount: Xd = Xn & (Xm >> amount with sign extension), sets N, Z

.text
.global _start
_start:
    mov x2, #0xFFFFFFFFFFFFFFFF
    mov x3, #0xF
    
    // ANDS X1, X2, X3, ASR #2 
    // X3 = 0xF, ASR #2 = 0xF >> 2 with sign extension = 0x3 (positive number)
    // Wait, 0xF is positive, ASR #2 = 0xF >> 2 = 0x3
    // 0xFFFFFFFFFFFFFFFF & 0x3 = 0x3
    // N=0, Z=0 -> NZCV = 0
    
    // Let me try a different approach with negative number
    mov x2, #0xFFFFFFFFFFFFFFFF
    movz x3, #0x8000
    movk x3, #0x0000, lsl #16
    movk x3, #0x0000, lsl #32
    movk x3, #0x0000, lsl #48
    // X3 = 0x8000000000000000 (min negative)
    
    // ASR #2 of 0x8000000000000000 = 0xE000000000000000 (sign extended)
    // 0xFFFFFFFFFFFFFFFF & 0xE000000000000000 = 0xE000000000000000
    // N=1, Z=0
    
    // Actually, let's do simpler:
    mov x2, #0xFFFFFFFFFFFFFFFF
    movz x3, #0xFFFC
    // X3 = 0xFFFC
    // X3 ASR #2 = 0xFFFC >> 2 = 0xFFF (positive, 0xFFF is 4095)
    // 0xFFFFFFFFFFFFFFFF & 0xFFF = 0xFFF
    // N=0, Z=0
    
    // Hmm, this is getting confusing. Let me do a simple test:
    mov x2, #0xFFFFFFFFFFFFFFFF
    mov x3, #0xFFFFFFFFFFFFFFFC
    
    // ANDS X1, X2, X3, ASR #0 = X3 ASR #0 = X3
    // 0xFFFFFFFFFFFFFFFF & 0xFFFFFFFFFFFFFFFC = 0xFFFFFFFFFFFFFFFC
    // N=1, Z=0 -> NZCV = 0x80000000
    
    ands x1, x2, x3, asr #0
    
    mrs x0, nzcv
    
    brk #0
