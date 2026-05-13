/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x00000000A0000000",
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
    // RBIT with flags checks
    // ========================================

    // Test 0: RBIT of 0 (result is 0, Z=1)
    mov x10, #0
    rbit x11, x10
    subs x12, x11, #0
    mrs x0, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 1: RBIT of 1 (result has sign bit set)
    mov x10, #1
    rbit x11, x10            // bit 0 -> bit 63
    subs x12, x11, #0        // result = 0x8000000000000000
    mrs x1, nzcv             // Expected: N=1, C=1 (0xA0000000)

    // Test 2: RBIT of all ones (all ones, N=1)
    mov x10, #1
    neg x10, x10             // x10 = -1 (all ones)
    rbit x11, x10
    adds x12, x11, #1        // result + 1 = 0, carry out
    mrs x2, nzcv             // Expected: Z=1, C=1 (0x60000000)

    // Test 3: RBIT of 0x8000000000000000 (result is 1)
    mov x10, #1
    lsl x10, x10, #63        // x10 = 0x8000000000000000
    rbit x11, x10            // bit 63 -> bit 0
    subs x12, x11, #1
    mrs x3, nzcv             // Expected: Z=1, C=1 (0x60000000)

    brk #0