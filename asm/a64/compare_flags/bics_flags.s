/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x40000000",
    "X1": "0x40000000",
    "X2": "0x80000000",
    "X3": "0x80000000"
  }
}
*/
// Test: BICS - Bit Clear with Set Flags
// BICS Wd, Wn, Wm: Wd = Wn AND (NOT Wm)
// Sets N and Z only (C=0, V=0 for logical ops)

.text
.global _start
_start:
    // Test 1: BICS with result = 0
    // 0 AND (NOT 0) = 0 AND 0xFFFFFFFF = 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov w11, #0
    mov w12, #0
    bics w13, w11, w12
    mrs x0, nzcv

    // Test 2: BICS clearing high bit
    // 0x80000000 AND (NOT 0x80000000) = 0x80000000 AND 0x7FFFFFFF = 0
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    mov w11, #0x80000000
    mov w12, #0x80000000
    bics w13, w11, w12
    mrs x1, nzcv

    // Test 3: BICS preserving all bits
    // 0xFFFFFFFF AND (NOT 0) = 0xFFFFFFFF AND 0xFFFFFFFF = 0xFFFFFFFF
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov w11, #-1
    mov w12, #0
    bics w13, w11, w12
    mrs x2, nzcv

    // Test 4: BICS partial clear, result negative
    // 0xFFFFFFFF AND (NOT 0x7FFFFFFF) = 0xFFFFFFFF AND 0x80000000 = 0x80000000
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    mov w11, #-1
    mov w12, #0x7FFFFFFF
    bics w13, w11, w12
    mrs x3, nzcv

    brk #0
