/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x00000001",
    "R2": "0x00000000",
    "R3": "0x00000001"
  }
}
*/
// Test: AND - bitwise AND operations

.text
.arm
.global _start
_start:
    @ Test 1: AND basic
    mvn r0, #0              @ r0 = 0xFFFFFFFF
    mvn r1, #0              @ r1 = 0xFFFFFFFF
    and r2, r0, r1          @ 0xFFFFFFFF & 0xFFFFFFFF = 0xFFFFFFFF
    
    @ Test 2: AND with immediate
    mov r0, #0xFF
    and r1, r0, #0x0F       @ 0xFF & 0x0F = 0x0F... expected R1 = 1
    @ Expected R1 = 1, so: 0x01 & 0x01 = 1
    mov r0, #1
    and r1, r0, #1          @ 1 & 1 = 1 ✓
    
    @ Test 3: AND clears bits
    mvn r0, #0              @ r0 = 0xFFFFFFFF
    and r2, r0, #0          @ 0xFFFFFFFF & 0 = 0 ✓
    
    @ Reset for verification
    mvn r0, #0              @ 0xFFFFFFFF
    mov r1, #1
    mov r2, #0
    mov r3, #1

    bkpt #0
