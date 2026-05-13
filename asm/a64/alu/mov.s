/* CONFIG
{
  "Match": "All",
  "X0": "0x000000000000002A",
  "X1": "0x000000000000002A"
}
*/
// Test: MOV Xt, Xn - Move register
// Copies value from one register to another

.text
.global _start
_start:
    mov x0, #42
    
    // MOV: move register
    mov x1, x0
    
    brk #0
