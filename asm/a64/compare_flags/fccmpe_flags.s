/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x80000000",
    "X1": "0x60000000",
    "X2": "0x20000000",
    "X3": "0x30000000",
    "X4": "0x00000000",
    "X5": "0x30000000",
    "X6": "0x80000000",
    "X7": "0x60000000"
  },
  "VecData": {}
}
*/
.arch armv8.4-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // FCCMPE - Floating-point Conditional Compare (with Exception)
    // FCCMPE Sd, Sn, #nzcv, cond
    // If cond is true: compare Sd vs Sn and set NZCV
    // If cond is false: set NZCV = #nzcv immediate
    // FCCMPE also signals Invalid Operation for NaN (unlike FCCMP)
    // ========================================

    // Setup floating-point values
    mov w10, #0x3F800000      // 1.0
    mov w11, #0x40000000      // 2.0
    fmov s0, w10              // s0 = 1.0
    fmov s1, w11              // s1 = 2.0

    // Test 1: FCCMPE with condition TRUE (EQ) - compare 1.0 vs 2.0 -> Less
    mov x20, #0
    msr nzcv, x20             // Clear NZCV
    cmp x20, x20              // Set Z flag (EQ condition true)
    fccmpe s0, s1, #0, eq     // EQ true, compare 1.0 < 2.0 -> Less
    mrs x0, nzcv              // Expected: 0x80000000 (N=1)

    // Test 2: FCCMPE with condition TRUE (EQ) - compare equal -> Equal
    mov x21, #0
    msr nzcv, x21
    cmp x21, x21
    fccmpe s0, s0, #0, eq     // EQ true, compare 1.0 == 1.0 -> Equal
    mrs x1, nzcv              // Expected: 0x60000000 (Z=1, C=1)

    // Test 3: FCCMPE with condition TRUE (EQ) - compare 2.0 > 1.0 -> Greater
    mov x22, #0
    msr nzcv, x22
    cmp x22, x22
    fccmpe s1, s0, #0, eq     // EQ true, compare 2.0 > 1.0 -> Greater
    mrs x2, nzcv              // Expected: 0x20000000 (C=1)

    // Test 4: FCCMPE with condition TRUE - NaN -> Unordered
    mov w12, #0x7FC00000      // quiet NaN
    fmov s2, w12
    mov x23, #0
    msr nzcv, x23
    cmp x23, x23
    fccmpe s2, s0, #0, eq     // EQ true, NaN vs 1.0 -> Unordered
    mrs x3, nzcv              // Expected: 0x30000000 (C=1, V=1)

    // Test 5: FCCMPE with condition FALSE - use immediate NZCV
    mov x24, #0x10000000      // Some flags set
    msr nzcv, x24
    mov x25, #1
    cmp x25, #0               // NE condition (x25 != 0 -> false, actually NE true when Z=0)
    // Wait, let me think: NE is true when Z=0
    // cmp x25, #0 sets Z=0 (since 1 != 0), so NE is true
    // To make condition false, we need to use EQ when Z=0
    cmp x25, #1               // x25 == 1, sets Z=1, so EQ is true
    // Actually for condition FALSE, we want: condition that is NOT met
    // Let's use EQ when values are not equal
    mov x26, #5
    cmp x26, #10              // 5 != 10, Z=0, EQ is false
    fccmpe s0, s1, #0, eq     // EQ false, set NZCV = #0
    mrs x4, nzcv              // Expected: 0x00000000 (immediate value)

    // Test 6: FCCMPE with condition FALSE - use immediate 0x30000000
    mov x27, #0
    msr nzcv, x27
    mov x28, #3
    cmp x28, #7               // 3 != 7, Z=0, EQ is false
    fccmpe s0, s1, #3, eq     // EQ false, set NZCV = #3 (0x30000000 in NZCV format)
    mrs x5, nzcv              // Expected: 0x30000000

    // Test 7: FCCMPE with MI condition (N=1, i.e., Less result from previous)
    // First set N flag
    mov x29, #0x80000000
    msr nzcv, x29             // N=1, MI condition true
    fccmpe s0, s1, #0, mi     // MI true (N=1), compare 1.0 < 2.0 -> Less
    mrs x6, nzcv              // Expected: 0x80000000

    // Test 8: FCCMPE with PL condition (N=0, i.e., Plus/Positive)
    mov x30, #0
    msr nzcv, x30             // N=0, PL condition true
    fccmpe s0, s0, #0, pl     // PL true (N=0), compare 1.0 == 1.0 -> Equal
    mrs x7, nzcv              // Expected: 0x60000000

    brk #0
