/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000002"
  }
}
*/
// Test: Conditional branch B.LT - branch if less than (N!=V)

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    
    cmp x0, x1          // 0 - 1 = -1, N=1, V=0, N!=V -> LT true
    b.lt less
    
    mov x0, #0
    mov x1, #0
    b done
    
less:
    mov x0, #1
    mov x1, #2
    
done:
    brk #0
