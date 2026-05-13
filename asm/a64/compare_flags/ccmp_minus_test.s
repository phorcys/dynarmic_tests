/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "W6": "0x0000000000000003",
    "W0": "0x0000000000000001"
  }
}
*/
.text
.global _start
_start:
    // Test: c = '-' (0x2d = 45)
    // w6 = 0x2d initially
    
    mov w6, #0x2d             // c = '-'
    
    // 101a8: sub w0, w6, #0x30
    sub w0, w6, #0x30         // w0 = 0x2d - 0x30 = -3 (wrapped to 0xfffffffd)
    
    // 101ac: and w0, w0, #0xff
    and w0, w0, #0xff         // w0 = 0xfd = 253
    
    // 101b0: cmp w0, #0x9
    cmp w0, #0x9              // Compare 253 with 9
    // 253 > 9, so Z=0, C=1 (no borrow), N=1, V=0
    // NZCV = 0xA0000000
    
    // 101b4: b.ls 10238 (digit check)
    b.ls digit_label          // LS = C==0 || Z==1 = false || false = FALSE
    // Should NOT jump to digit
    
    // 101b8: and w0, w6, #0xfffffffd
    and w0, w6, #0xfffffffd   // w0 = 0x2d & 0xfffffffd = 0x2d
    
    // 101bc: sub w6, w6, #0x2a
    sub w6, w6, #0x2a         // w6 = 0x2d - 0x2a = 3
    
    // 101c0: and w6, w6, #0xff
    and w6, w6, #0xff         // w6 = 3
    
    // 101c4: cmp w0, #0x2d
    cmp w0, #0x2d             // Compare 0x2d with 0x2d
    // Equal! Z=1, C=1, N=0, V=0
    // NZCV = 0x40000000
    
    // 101c8: ccmp w6, #0x1, #0x0, ne
    ccmp w6, #0x1, #0x0, ne   // NE condition: Z==0
    // Previous CMP set Z=1, so NE is FALSE
    // Therefore NZCV = 0x0 (else_flags = 0 << 28)
    // NZCV = 0x00000000 (C=0, Z=0)
    
    // 101cc: b.ls 10220 (operator check)
    b.ls operator_label       // LS = C==0 || Z==1 = true || false = TRUE
    // Should JUMP to operator!
    
    mov w0, #0                // unknown - should not reach
    brk #0
    
digit_label:
    mov w0, #2                // digit - should not reach
    brk #0
    
operator_label:
    mov w0, #1                // operator - should reach
    brk #0
