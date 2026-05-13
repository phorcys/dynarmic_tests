/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x7FFFFFFFFFFFFFFF"
  }
}
*/
// Test: BICS with LSL shift 63 - Bit Clear with flag set

.text
.global _start
_start:
    mov x2, #0xFFFFFFFFFFFFFFFF
    mov x3, #1
    
    // BICS X1, X2, X3, LSL #63 = 0xFFFFFFFFFFFFFFFF & ~(1 << 63)
    // 1 << 63 = 0x8000000000000000
    // ~0x8000000000000000 = 0x7FFFFFFFFFFFFFFF
    // Result = 0x7FFFFFFFFFFFFFFF
    // N=0 (bit 63 = 0), Z=0 -> NZCV = 0
    
    bics x1, x2, x3, lsl #63
    
    mrs x0, nzcv
    
    brk #0
