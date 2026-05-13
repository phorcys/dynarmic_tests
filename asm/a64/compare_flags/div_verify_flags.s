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
    // SDIV/UDIV with flags tests
    // Note: Division doesn't set flags directly,
    // but we can use SUBS/CMP to check results
    // ========================================

    // Test 0: SDIV positive / positive
    mov x10, #100
    mov x11, #10
    sdiv x12, x10, x11           // 100 / 10 = 10
    subs x13, x12, #10           // check result is 10, Z=1, C=1 (no borrow)
    mrs x0, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    // Test 1: SDIV negative / positive
    mov x10, #100
    neg x10, x10                 // -100
    mov x11, #10
    sdiv x12, x10, x11           // -100 / 10 = -10
    mov x13, #10
    neg x13, x13                 // -10
    subs x14, x12, x13           // check result is -10, Z=1, C=1 (no borrow)
    mrs x1, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    // Test 2: UDIV 
    mov x10, #100
    mov x11, #10
    udiv x12, x10, x11           // 100 / 10 = 10
    subs x13, x12, #10           // check result is 10, Z=1, C=1 (no borrow)
    mrs x2, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    // Test 3: SDIV by zero (returns 0)
    mov x10, #100
    mov x11, #0
    sdiv x12, x10, x11           // division by zero returns 0
    subs x13, x12, #0            // check result is 0, Z=1, C=1 (no borrow)
    mrs x3, nzcv                 // Expected: Z=1, C=1 = 0x60000000

    brk #0