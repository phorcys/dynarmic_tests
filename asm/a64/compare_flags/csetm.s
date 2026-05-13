/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF",
    "X1": "0x0000000000000000",
    "X2": "0xFFFFFFFFFFFFFFFF",
    "X3": "0x0000000000000000"
  }
}
*/
// Test: CSETM Xd, cond - Conditional Set Mask
// If condition true, Xd = all 1s, else Xd = all 0s
// Alias for CSINV Xd, XZR, XZR, invert(cond)

.text
.global _start
_start:
    // Test 1: CSETM with EQ (equal) when Z=1
    mov x0, #5
    cmp x0, #5       // Sets Z=1 (equal)
    csetm x0, eq     // X0 = all 1s (0xFFFFFFFFFFFFFFFF)
    
    // Test 2: CSETM with NE (not equal) when Z=1
    csetm x1, ne     // X1 = 0 (condition false)
    
    // Test 3: CSETM with MI (minus/negative) when N=1
    mov x2, #-1
    cmp x2, #0       // N=1 (negative)
    csetm x2, mi     // X2 = all 1s
    
    // Test 4: CSETM with PL (plus/positive) when N=1
    csetm x3, pl     // X3 = 0 (condition false)

    brk #0
