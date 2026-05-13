/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000040000000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000080000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // TST (Test bits) - alias for ANDS with XZR
    // ========================================

    // Test 0: TST all bits set
    mov x10, #0xFF
    tst x10, #0xFF          // 0xFF & 0xFF = 0xFF (non-zero)
    mrs x0, nzcv            // Expected: no flags

    // Test 1: TST no bits set
    mov x10, #0xF0
    tst x10, #0x0F          // 0xF0 & 0x0F = 0
    mrs x1, nzcv            // Expected: Z=1

    // Test 2: TST with negative result
    mov x10, #1
    lsl x10, x10, #63       // x10 = 0x8000000000000000
    tst x10, x10            // bit 63 is set, result is negative
    mrs x2, nzcv            // Expected: N=1

    // Test 3: TST 32-bit
    mov w10, #0xFFFFFFFF
    tst w10, #0xFFFF0000    // all bits set
    mrs x3, nzcv            // Expected: N=1 (bit 31 set)

    brk #0