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
    // BFM (Bitfield Move) detailed tests
    // BFM Xd, Xn, #immr, #imms
    // Extracts bits [immr:imms] from Xn and inserts into Xd
    // ========================================

    // Test 0: BFM extracting low bits
    mov x10, #0xFF
    mov x11, #0
    bfm x11, x10, #0, #7     // extract bits 0-7 from x10, insert into x11
    // x11 = 0xFF
    subs x12, x11, #0xFF
    mrs x0, nzcv             // Expected: Z=1, C=1

    // Test 1: BFM extracting bits 8-15
    mov x10, #0xFF00         // x10 = 0xFF00
    mov x11, #0
    bfm x11, x10, #8, #15    // extract bits 8-15 from x10, insert into x11 bits 0-7
    // x11 = 0xFF
    subs x12, x11, #0xFF
    mrs x1, nzcv             // Expected: Z=1, C=1

    // Test 2: BFXIL (extract and insert low)
    mov x10, #0xFF00
    mov x11, #0
    bfxil x11, x10, #8, #8   // extract bits 8-15 from x10, insert into x11 bits 0-7
    subs x12, x11, #0xFF
    mrs x2, nzcv             // Expected: Z=1, C=1

    // Test 3: BFM with larger field
    mov x10, #0xFFF
    mov x11, #0
    bfm x11, x10, #0, #11    // extract bits 0-11 from x10, insert into x11
    subs x12, x11, #0xFFF
    mrs x3, nzcv             // Expected: Z=1, C=1

    brk #0
