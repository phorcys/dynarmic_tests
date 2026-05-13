/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000040000000",
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
    // Zero flag edge cases
    // ========================================

    // Test 0: Zero result from ADDS
    mov x10, #0
    mov x11, #0
    adds x12, x10, x11       // 0 + 0 = 0
    mrs x0, nzcv             // Expected: Z=1 (0x40000000)

    // Test 1: Zero result from SUBS (equal values)
    mov x10, #42
    mov x11, #42
    subs x12, x10, x11       // 42 - 42 = 0
    mrs x1, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 2: Zero result from ANDS
    mov x10, #0xFF
    mov x11, #0
    ands x12, x10, x11       // 0xFF & 0 = 0
    mrs x2, nzcv             // Expected: Z=1 (0x40000000)

    // Test 3: Zero result from EOR then check
    mov x10, #0xFF
    mov x11, #0xFF
    eor x12, x10, x11        // 0xFF ^ 0xFF = 0
    subs x13, x12, #0
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0
