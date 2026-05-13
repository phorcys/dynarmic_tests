/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000014"
}
*/
// Test: MUL Xt, Xn, Xm - Multiply
// Multiplies two register values (alias for MADD with XZR)

.text
.global _start
_start:
    mov x0, #7
    mov x1, #4
    
    // MUL: multiply
    mul x0, x0, x1
    
    brk #0
