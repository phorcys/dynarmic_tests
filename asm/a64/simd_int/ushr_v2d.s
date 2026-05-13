/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000020000000000000001",
    "Q1": "0x00000000000000010000000000000000"
  }
}
*/
// Test: USHR Vd.2D, Vn.2D, #1 - unsigned shift right by immediate

.text
.global _start
_start:
    // Load Q0 with [1, 2] as two 64-bit values
    mov x0, #1
    mov v0.d[0], x0
    
    mov x1, #2
    mov v0.d[1], x1
    
    // USHR: Q1 = Q0 >> 1
    // [1, 2] >> 1 = [0, 1]
    ushr v1.2d, v0.2d, #1

    brk #0
