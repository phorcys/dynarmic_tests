/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000001",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000001",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000001"
  }
}
*/
.text
.global _start
_start:
    // Test HI (C==1 && Z==0) and LS (C==0 || Z==1)

    // Test 1: C=1, Z=0 (HI true, LS false)
    // NZCV: N=0, Z=0, C=1, V=0 -> 0x20000000
    mov x10, #0x20000000
    msr nzcv, x10

    mov x11, #1
    mov x12, #0

    csel x0, x11, x12, hi   // HI true (C=1, Z=0): x0 = 1
    csel x1, x11, x12, ls   // LS false (C=1, Z=0): x1 = 0

    // Test 2: C=0, Z=0 (HI false, LS true)
    // NZCV: N=0, Z=0, C=0, V=0 -> 0x00000000
    mov x10, #0x00000000
    msr nzcv, x10

    csel x2, x11, x12, hi   // HI false (C=0): x2 = 0
    csel x3, x11, x12, ls   // LS true (C=0): x3 = 1

    // Test 3: C=1, Z=1 (HI false, LS true)
    // NZCV: N=0, Z=1, C=1, V=0 -> 0x60000000
    mov x10, #0x60000000
    msr nzcv, x10

    csel x4, x11, x12, hi   // HI false (Z=1): x4 = 0
    csel x5, x11, x12, ls   // LS true (Z=1): x5 = 1

    // Test 4: C=0, Z=1 (HI false, LS true)
    // NZCV: N=0, Z=1, C=0, V=0 -> 0x40000000
    mov x10, #0x40000000
    msr nzcv, x10

    csel x6, x11, x12, hi   // HI false (C=0): x6 = 0
    csel x7, x11, x12, ls   // LS true (C=0 || Z=1): x7 = 1

    brk #0