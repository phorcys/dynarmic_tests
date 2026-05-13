/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000090000000",
    "X2": "0x0000000060000000"
  }
}
*/
.text
.global _start
_start:
    // Test 64-bit boundary values

    // Test 1: 0 - 1 (64-bit, negative result)
    mov x11, #0
    mov x12, #1
    subs x13, x11, x12       // 0 - 1 = -1, flags: N=1, Z=0, C=0, V=0
    mrs x0, nzcv
    // Expected: 0x80000000 (NZCV is 32-bit)

    // Test 2: INT64_MAX + 1 (signed overflow)
    mov x11, #0x7FFFFFFFFFFFFFFF
    mov x12, #1
    adds x13, x11, x12       // INT64_MAX + 1 = 0x8000000000000000, flags: N=1, Z=0, C=0, V=1
    mrs x1, nzcv
    // Expected: N=1, Z=0, C=0, V=1 -> 0x90000000

    // Test 3: MAX_UINT64 + 1 (unsigned carry)
    mov x11, #0xFFFFFFFFFFFFFFFF
    mov x12, #1
    adds x13, x11, x12       // MAX_UINT64 + 1 = 0, flags: N=0, Z=1, C=1, V=0
    mrs x2, nzcv
    // Expected: N=0, Z=1, C=1, V=0 -> 0x60000000

    brk #0