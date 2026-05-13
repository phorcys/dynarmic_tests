/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0xFF00FF00FF00FF00FF00FF00FF00FF00",
    "Q1": "0x00FF00FF00FF00FF00FF00FF00FF00FF"
  }
}
*/
// Test: MVN (NOT) - bitwise complement
// V1 = NOT(V0) = ~0xFF00... = 0x00FF...

.text
.global _start
_start:
    // Load V0 with pattern 0xFF00FF00...
    mov x0, #0xFF00
    movk x0, #0xFF00, lsl #16
    movk x0, #0xFF00, lsl #32
    movk x0, #0xFF00, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0
    
    // NOT
    mvn v1.16b, v0.16b

    brk #0
