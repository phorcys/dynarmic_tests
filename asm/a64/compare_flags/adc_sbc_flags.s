/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000080000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // ADC/ADCS/SBC/SBCS - with carry/borrow
    // ========================================

    // Test 0: ADC with C=0 -> just add
    mov x10, #10
    mov x11, #5
    msr nzcv, xzr                 // Clear flags, C=0
    adc x12, x10, x11             // 10 + 5 + 0 = 15
    adds x13, x12, xzr            // Check result
    mrs x0, nzcv                  // Expected: N=0, Z=0, C=0, V=0 = 0x00000000 (result 15)

    // Test 1: ADC with C=1 -> add with carry
    mov x10, #10
    mov x11, #5
    mov x14, #0x20000000
    msr nzcv, x14                 // Set C=1
    adc x12, x10, x11             // 10 + 5 + 1 = 16
    adds x13, x12, xzr            // Check result
    mrs x1, nzcv                  // Expected: N=0, Z=0, C=0, V=0 = 0x00000000 (result 16)

    // Test 2: ADCS with C=1 -> add with carry, set flags
    mov x10, #10
    mov x11, #5
    mov x14, #0x20000000
    msr nzcv, x14                 // Set C=1
    adcs x12, x10, x11            // 10 + 5 + 1 = 16
    mrs x2, nzcv                  // Expected: N=0, Z=0, C=0, V=0 = 0x00000000

    // Test 3: SBC with C=1 -> subtract without borrow
    mov x10, #10
    mov x11, #5
    mov x14, #0x20000000
    msr nzcv, x14                 // Set C=1 (no borrow)
    sbc x12, x10, x11             // 10 - 5 - 0 = 5
    adds x13, x12, xzr
    mrs x3, nzcv                  // Expected: N=0, Z=0, C=0, V=0 = 0x00000000 (result 5)

    // Test 4: SBC with C=0 -> subtract with borrow
    mov x10, #10
    mov x11, #5
    msr nzcv, xzr                 // Clear flags, C=0 (borrow)
    sbc x12, x10, x11             // 10 - 5 - 1 = 4
    adds x13, x12, xzr
    mrs x4, nzcv                  // Expected: N=0, Z=0, C=0, V=0 = 0x00000000 (result 4)

    // Test 5: SBCS with C=0 -> subtract with borrow, set flags
    mov x10, #10
    mov x11, #10
    msr nzcv, xzr                 // Clear flags, C=0 (borrow)
    sbcs x12, x10, x11            // 10 - 10 - 1 = -1
    mrs x5, nzcv                  // Expected: N=1, Z=0, C=0, V=0 = 0x80000000

    brk #0