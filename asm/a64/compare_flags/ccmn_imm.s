/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Test: CCMN Xn, #imm, #nzcv, #cond - Conditional Compare Negative (immediate)
// If condition true: compare Xn with -imm and set flags
// If condition false: set flags to nzcv

.text
.global _start
_start:
    mov x0, #5
    cmp x0, #5       // Sets Z=1 (equal)
    
    // CCMN with immediate: if EQ, compare x0 with -5 (i.e., check if x0 == 5)
    // Since EQ is true, compare x0 (5) with -5 (negated immediate)
    // 5 compared with -5: not equal, so Z=0
    // But CCMN compares with the NEGATED immediate, so 5 vs 5? No...
    // CCMN Xn, #imm compares Xn with -(imm), sets flags
    // So CCMN x0, #5 compares x0 with -5
    // 5 vs -5: N=1, Z=0, C=0, V=0
    
    ccmn x0, #5, #0, eq
    
    // Get Z flag
    mrs x0, nzcv
    lsr x0, x0, #30   // Shift to get Z in bit 0
    and x0, x0, #1    // Z flag

    brk #0