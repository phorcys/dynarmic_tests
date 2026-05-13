/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X3": "0x0000000000005678",
    "X4": "0xFFFFFFFF80000000"
  }
}
*/
// Test: LDPSW with negative value - sign extension
// LDPSW loads two 32-bit values, sign-extends them to 64-bit

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #64
    
    mov x0, sp
    mov w1, #0x5678
    mov w2, #-2147483648   // 0x80000000 (negative in signed 32-bit)
    
    // Store two 32-bit values (w1 at [sp], w2 at [sp+4])
    stp w1, w2, [x0]
    
    // LDPSW: load as signed 32-bit, sign-extend to 64-bit
    ldpsw x3, x4, [x0]     // x3 = 0x5678, x4 = sign-extended 0x80000000 = 0xFFFFFFFF80000000
    
    add sp, sp, #64
    brk #0