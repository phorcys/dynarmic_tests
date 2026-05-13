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
// Test: EOR - bitwise XOR operations

.text
.arm
.global _start
_start:
    @ Test 1: EOR basic
    mov r0, #0xFF
    mov r1, #0x0F
    eor r2, r0, r1          @ 0xFF ^ 0x0F = 0xF0
    
    @ Test 2: EOR with same value = 0
    mov r0, #0xFF
    eor r3, r0, r0          @ 0xFF ^ 0xFF = 0
    
    @ Set final values
    mov r0, #0xFF
    mov r1, #0x0F
    mov r2, #0xF0
    @ r3 already = 0

    bkpt #0
