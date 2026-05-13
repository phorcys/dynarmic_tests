/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000001",
    "X5": "0x0000000000000000"
  }
}
*/
.text
.global _start
_start:
    // Test MI (N=1, minus/negative) and PL (N=0, plus/positive)

    // Test 1: N=0 (MI false, PL true)
    mov x10, #0x00000000    // N=0, Z=0, C=0, V=0
    msr nzcv, x10

    mov x11, #1
    mov x12, #0

    csel x0, x11, x12, mi   // MI false (N=0): x0 = 0
    csel x1, x11, x12, pl   // PL true (N=0): x1 = 1

    // Test 2: N=1 (MI true, PL false)
    mov x10, #0x80000000    // N=1, Z=0, C=0, V=0
    msr nzcv, x10

    csel x2, x11, x12, mi   // MI true (N=1): x2 = 1
    csel x3, x11, x12, pl   // PL false (N=1): x3 = 0

    // Test 3: N=1, Z=1 (result is zero but N=1)
    mov x10, #0xC0000000    // N=1, Z=1, C=0, V=0
    msr nzcv, x10

    csel x4, x11, x12, mi   // MI true (N=1): x4 = 1
    csel x5, x11, x12, pl   // PL false (N=1): x5 = 0

    brk #0