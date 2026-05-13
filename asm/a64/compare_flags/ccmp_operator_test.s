/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "W6": "0x00000000000000D6",
    "W0": "0x0000000000000000"
  }
}
*/
.text
.global _start
_start:
    // Simulate: c = '-' (0x2d = 45)
    // W6 = 0 (after sub w6, w6, #0x2a for c='-')
    
    mov w6, #0        // Simulating w6=0 after sub
    and w0, w6, #0xfffffffd  // w0 = 0 & 0xfffffffd = 0
    sub w6, w6, #0x2a        // w6 = 0 - 0x2a = -0x2a (wrapped)
    and w6, w6, #0xff        // w6 = lower 8 bits = 0xd6
    cmp w0, #0x2d            // Compare 0 with 0x2d
    // 0 != 0x2d, so Z=0, C=0 (unsigned borrow), N=1, V=0
    // NZCV = 0x80000000 (N=1, Z=0, C=0, V=0)
    
    ccmp w6, #0x1, #0x0, ne  // CCMP with NE condition (Z==0)
    // NE is TRUE because Z=0 from previous CMP
    // So execute the comparison: compare w6 (0xd6) with 1
    // 0xd6 (214) != 1, so Z=0
    // For unsigned comparison: 214 >= 1, so C=1
    // N=0 (214-1 is positive)
    // V=0 (no overflow for subtract)
    // NZCV = 0x20000000 (Z=0, C=1)
    
    b.ls operator_label
    // LS = C==0 || Z==1
    // With NZCV = 0x40000000: C=1, Z=0
    // LS = false || false = FALSE
    // So should NOT take the branch
    mov w0, #0      // Not operator
    brk #0
operator_label:
    mov w0, #1      // Operator found
    brk #0
