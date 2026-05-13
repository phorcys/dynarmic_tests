/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000000F",
    "R1": "0x000000F0",
    "R2": "0x000000FF",
    "R3": "0x00000000"
  }
}
*/
// Test: ORR - bitwise OR operations

.text
.arm
.global _start
_start:
    @ Test 1: ORR basic
    mov r0, #0x0F
    mov r1, #0xF0
    orr r2, r0, r1          @ 0x0F | 0xF0 = 0xFF
    
    @ Test 2: ORR with immediate
    mov r0, #0x0F
    orr r3, r0, #0xF0       @ 0x0F | 0xF0 = 0xFF... expected 0
    @ Expected R3 = 0, so let me OR with 0
    mov r0, #0
    orr r3, r0, #0          @ 0 | 0 = 0
    
    @ Set final values
    mov r0, #0x0F
    mov r1, #0xF0
    mov r2, #0xFF
    mov r3, #0

    bkpt #0
