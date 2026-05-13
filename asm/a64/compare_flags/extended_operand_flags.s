/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000020000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // Extended register operands
    // <op> <Rd>, <Rn>, <Rm>{, <extend> {#<amount>}}
    // ========================================

    // Test 0: ADD with SXTW (Sign Extend Word)
    mov w10, #0x7FFFFFFF    // max positive 32-bit
    sxtw x11, w10           // sign extend to 64-bit
    add x12, x11, #1
    subs x13, x12, #0       // check result
    mrs x0, nzcv            // Expected: C=1

    // Test 1: ADD with UXTW (Zero Extend Word)
    mov w10, #0xFFFFFFFF
    mov x11, #0
    add x12, x11, w10, uxtw // zero extend and add
    mov x13, #1
    lsl x13, x13, #32
    subs x13, x13, #1       // x13 = 0xFFFFFFFF
    subs x14, x12, x13      // compare
    mrs x1, nzcv            // Expected: Z=1, C=1

    // Test 2: SUB with SXTB (Sign Extend Byte)
    mov w10, #0x80          // negative byte (-128)
    sxtb x11, w10           // sign extend
    mov x12, #0
    sub x13, x12, x11       // 0 - (-128) = 128
    subs x14, x13, #128
    mrs x2, nzcv            // Expected: Z=1, C=1

    // Test 3: SUB with SXTH (Sign Extend Halfword)
    mov w10, #0x8000        // negative halfword (-32768)
    sxth x11, w10           // sign extend
    mov x12, #0
    sub x13, x12, x11       // 0 - (-32768) = 32768
    subs x14, x13, #0
    mrs x3, nzcv            // Expected: C=1

    brk #0