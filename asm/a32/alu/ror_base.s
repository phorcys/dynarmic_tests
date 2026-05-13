/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xC0000003",
    "R1": "0x00000006",
    "R2": "0x0000000C",
    "R3": "0x00000003"
  }
}
*/
// Test: ROR - rotate right

.text
.arm
.global _start
_start:
    @ Test 1: ROR by 2
    @ 0x0F = 0000...1111
    @ ror 2: bottom 2 bits (11) wrap to top, rest shifts right
    @ = 1100 0000 ... 0011 = 0xC0000003
    mov r4, #0xF
    mov r0, r4, ror #2
    
    @ Test 2: ROR by 4
    @ 0x60 = 0110 0000
    @ ror 4: bottom 4 bits (0000) go to top, 0110 goes to bottom
    @ = 0000 ... 0110 = 0x06
    mov r4, #0x60
    mov r1, r4, ror #4
    
    @ Test 3: ROR by 8
    @ 0x0C00 ror 8 = 0x0000000C
    mov r4, #0xC00
    mov r2, r4, ror #8
    
    @ Test 4: ROR by 0 (no change)
    mov r4, #3
    mov r3, r4, ror #0
    
    bkpt #0
