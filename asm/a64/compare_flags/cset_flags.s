/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000001"
  }
}
*/
// Test: Conditional Set (CSET, CSETM, CINC, CINV, CNEG)
// These set values based on condition flags

.text
.global _start
_start:
    // Set up initial flags: N=0, Z=0, C=1, V=0 (0x20000000)
    mov w11, #1
    cmp w11, #0              // 1 > 0, N=0, Z=0, C=1, V=0

    // Test 1: CSET (Conditional Set)
    // CSET Wd, cond: if cond then 1 else 0
    cset w12, hi             // HI true (C=1), so w12 = 1
    mov w0, w12              // x0 = 1

    // Test 2: CSET with false condition
    cset w12, eq             // EQ false (Z=0), so w12 = 0
    mov w1, w12              // x1 = 0

    // Test 3: CSETM (Conditional Set Mask)
    // CSETM Wd, cond: if cond then -1 (all 1s) else 0
    csetm w12, hi            // HI true, so w12 = 0xFFFFFFFF
    add w2, w12, #1          // x2 = 0xFFFFFFFF + 1 = 0 (wraps to 0)

    // Test 4: CINC (Conditional Increment)
    // CINC Wd, Wn, cond: if cond then (Wn + 1) else Wn
    mov w12, #0
    cinc w13, w12, hi        // HI true, so w13 = 0 + 1 = 1
    mov w3, w13              // x3 = 1

    brk #0