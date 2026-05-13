/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000001"
  }
}
*/
.text
.global _start
_start:
    // Test 64-bit condition chains

    // Test 1: CMP with 64-bit values
    mov x11, #0x100000000
    mov x12, #0x100000000
    cmp x11, x12               // Equal, Z=1
    cset x0, eq                // x0 = 1 (condition true)

    // Test 2: 64-bit comparison with larger values
    mov x11, #0x200000000
    mov x12, #0x100000000
    cmp x11, x12               // x11 > x12 (unsigned)
    // HI: C==1 (unsigned higher)
    cset x1, hi                // x1 = 1 (C=1)

    // Test 3: LS (unsigned lower or same)
    // Same flags: C=1 (no borrow), Z=0
    // LS: C==0 || Z==1 -> false (C=1 && Z=0)
    cset x2, ls                // x2 = 0

    // Test 4: Signed comparison with negative 64-bit
    movn x11, #0, lsl #0       // x11 = 0xFFFFFFFFFFFFFFFF (-1)
    mov x12, #1
    cmp x11, x12               // -1 < 1 (signed comparison)
    // LT (signed less than): N!=V
    // After CMP: N=1 (result negative), V=0 (no overflow)
    // LT: 1!=0 -> true
    cset x3, lt                // x3 = 1

    brk #0