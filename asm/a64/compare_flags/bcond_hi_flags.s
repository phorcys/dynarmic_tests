/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000002"
  }
}
*/
// Test: Conditional branch B.HI - branch if higher (C=1 && Z=0)

.text
.global _start
_start:
    mov x0, #2
    mov x1, #1
    
    cmp x0, x1          // 2 - 1 = 1, C=1 (no borrow), Z=0
    b.hi higher
    
    mov x0, #0
    mov x1, #0
    b done
    
higher:
    mov x0, #1
    mov x1, #2
    
done:
    brk #0
