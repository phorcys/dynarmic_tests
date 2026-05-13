/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000F0000000",
    "X1": "0x0000000000000000",
    "X2": "0x0000000060000000",
    "X3": "0x0000000090000000"
  }
}
*/
.text
.global _start
_start:
    // Test all NZCV flags combinations

    // Test 1: N=1, Z=1, C=1, V=1 (all flags set)
    mov x10, #0xF0000000
    msr nzcv, x10
    mrs x0, nzcv
    // Expected: 0xF0000000

    // Test 2: N=0, Z=0, C=0, V=0 (all flags clear)
    mov x10, #0x00000000
    msr nzcv, x10
    mrs x1, nzcv
    // Expected: 0x00000000

    // Test 3: N=0, Z=1, C=1, V=0
    mov x10, #0x60000000
    msr nzcv, x10
    mrs x2, nzcv
    // Expected: 0x60000000

    // Test 4: N=1, Z=0, C=0, V=1
    mov x10, #0x90000000
    msr nzcv, x10
    mrs x3, nzcv
    // Expected: 0x90000000

    brk #0
