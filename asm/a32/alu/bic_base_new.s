/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x000000FF",
    "R1": "0x0000000F",
    "R2": "0x000000F0",
    "R3": "0x00000000"
  }
}
*/
// Test: BIC - bit clear (AND NOT)
// BIC Rd, Rn, Operand2: Rd = Rn & ~Operand2

.text
.arm
.global _start
_start:
    @ Test 1: BIC clears lower 4 bits
    mov r0, #0xFF
    mov r1, #0x0F
    bic r2, r0, r1          @ 0xFF & ~0x0F = 0xFF & 0xF0 = 0xF0
    
    @ Test 2: BIC clears all bits
    mov r0, #0xFF
    mvn r1, #0              @ r1 = 0xFFFFFFFF
    bic r3, r0, r1          @ 0xFF & ~0xFFFFFFFF = 0xFF & 0 = 0
    
    @ Set final values
    mov r0, #0xFF
    mov r1, #0x0F
    mov r2, #0xF0
    @ r3 already = 0

    bkpt #0
