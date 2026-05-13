/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000060000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Bitfield insert with flags verification
    // BFI/BFXIL don't set flags, verify with SUBS
    // ========================================

    // Test 0: BFI - Bitfield insert
    mov x10, #0
    mov x11, #0xFF
    bfi x10, x11, #8, #8         // insert 8 bits of 0xFF at position 8
    // x10 = 0x0000FF00
    mov x12, #0xFF00
    subs x13, x10, x12           // verify
    mrs x0, nzcv                 // Expected: Z=1, C=1

    // Test 1: BFXIL - Bitfield extract and insert low
    mov x10, #0xFF00
    mov x11, #0xFF
    bfxil x10, x11, #0, #8       // extract low 8 bits from x11 and insert to x10 low 8 bits
    // x10 = 0xFF00 | 0xFF = 0xFFFF (wait, that's not right)
    // Actually BFXIL copies bits from source to dest, overwriting low bits
    // BFXIL Xd, Xn, #lsb, #width: copies width bits from Xn[0:width-1] to Xd[lsb:lsb+width-1]
    // Actually: Xd[0:width-1] = Xn[lsb:lsb+width-1]
    // So: x10[0:7] = x11[0:7] = 0xFF
    // x10 was 0xFF00, now low 8 bits become 0xFF, so x10 = 0xFF00 with low bits = 0xFF
    // Wait that doesn't make sense either. Let me check the actual semantics.
    // BFXIL Xd, Xn, #lsb, #width: Xd[0:width-1] = Xn[lsb:lsb+width-1]
    // So if x10=0xFF00, x11=0xFF, lsb=0, width=8:
    // x10[0:7] = x11[0:7] = 0xFF
    // x10 becomes: 0xFF00 & ~0xFF | 0xFF = 0xFF00 | 0xFF = 0xFFFF? No wait...
    // The high bits of x10 stay the same, only low 8 bits change
    // x10 = (x10 & ~0xFF) | (x11 & 0xFF)
    // x10 = (0xFF00 & ~0xFF) | (0xFF & 0xFF) = 0xFF00 | 0xFF = 0xFFFF
    mov x12, #0xFFFF
    subs x13, x10, x12           // verify
    mrs x1, nzcv                 // Expected: Z=1, C=1

    // Test 2: SBFIZ - Signed bitfield insert zero
    mov x10, #0
    mov x11, #1
    lsl x11, x11, #7             // x11 = 0x80 (bit 7 set)
    sbfiz x10, x11, #0, #8       // sign extend 8 bits starting from bit 0
    // x11[7] = 1 (negative in 8-bit), so sign extend
    // x10 = 0xFFFFFFFFFFFFFF80
    mov x12, #1
    lsl x12, x12, #63            // sign bit
    asr x12, x12, #56            // 0xFFFFFFFFFFFFFF80
    subs x13, x10, x12           // verify
    mrs x2, nzcv                 // Expected: Z=1, C=1

    // Test 3: UBFIZ - Unsigned bitfield insert zero
    mov x10, #0
    mov x11, #0x80
    ubfiz x10, x11, #8, #8       // unsigned, no sign extend
    // x10 = 0x80 << 8 = 0x8000
    mov x12, #0x8000
    subs x13, x10, x12           // verify
    mrs x3, nzcv                 // Expected: Z=1, C=1

    brk #0
