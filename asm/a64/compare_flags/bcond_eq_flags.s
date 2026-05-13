/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000002"
  }
}
*/
// Test: Conditional branch B.EQ - branch if equal (Z=1)

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    
    cmp x0, x1          // 0 - 0 = 0, Z=1
    b.eq equal
    
    mov x0, #0
    mov x1, #0
    b done
    
equal:
    mov x0, #1
    mov x1, #2
    
done:
    brk #0
