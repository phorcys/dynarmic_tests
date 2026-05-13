/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "W0": "0x0000000000000001",
    "W6": "0x0000000000000000"
  }
}
*/
.text
.global _start
_start:
    // W0 = 0x2d (45 = '-')
    // W6 = 0
    
    mov w0, #0x2d
    cmp w0, #0x2d
    // Comparing 0x2d with 0x2d, they are equal
    // Z=1, C=1, N=0, V=0
    // NZCV = 0x40000000
    
    // CCMP w6, #0x1, #0x0, ne
    // NE condition: Z == 0 (checking if previous CMP result was "not equal")
    // Previous CMP set Z=1, so NE is FALSE
    // Therefore NZCV = 0x0 (the else_flags = nzcv << 28 = 0 << 28)
    ccmp w6, #0x1, #0x0, ne
    
    // With NZCV = 0x0: N=0, Z=0, C=0, V=0
    // LS condition: C==0 || Z==1 = true || false = TRUE
    // So b.ls SHOULD jump
    b.ls taken
    mov w0, #0      // Not taken - should not reach here
    brk #0
taken:
    mov w0, #1      // Taken - should reach here
    brk #0
