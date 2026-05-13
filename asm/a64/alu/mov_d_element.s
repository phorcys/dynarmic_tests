/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000040000000000000004"
}
*/
// Test: MOV Dd, Vn.D[index] - Move vector element to scalar register

.text
.global _start
_start:
    mov x0, #3
    mov x1, #4
    ins v0.d[0], x0
    ins v0.d[1], x1
    
    mov d1, v0.d[1]
    mov d0, v0.d[1]
    
    brk #0
