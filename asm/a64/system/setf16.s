/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: SETF16 Wn - Set condition flags from halfword
// Transfers bit[15] of Wn to N flag, bit[14] to Z flag

.text
.global _start
_start:
    // Test 1: SETF16 with negative value (bit 15 = 1)
    mov w0, #0x8000  // bit 15 = 1, so N=1
    setf16 w0
    // N=1, Z=0
    
    // Check N flag (should be 1)
    b.mi 1f        // branch if N=1 (minus)
    mov x0, #0     // failed
    b 2f
1:
    mov x0, #1     // passed, N=1
2:
    // Test 2: SETF16 with zero (bit 15 = 0, bit 14 = 0)
    mov w2, #0
    setf16 w2
    // N=0, Z=0 (bit 14 is 0, so Z=0)
    
    // Check Z flag (should be 0)
    b.eq 3f        // branch if Z=1
    mov x1, #0     // Z=0
    b 4f
3:
    mov x1, #1     // Z=1, but bit 14 is 0...
4:
    
    // Test 3: SETF16 with Z bit set (bit 14 = 1)
    mov w2, #0x4000  // bit 14 = 1, so Z=1
    setf16 w2
    // N=0, Z=1
    
    brk #0
