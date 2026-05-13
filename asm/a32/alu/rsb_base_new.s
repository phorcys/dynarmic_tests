/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000003",
    "R1": "0x00000005",
    "R2": "0xFFFFFFFE",
    "R3": "0x00000002"
  }
}
*/
// Test: RSB - reverse subtract
// RSB Rd, Rn, Operand2: Rd = Operand2 - Rn

.text
.arm
.global _start
_start:
    @ Test 1: RSB with immediate - 10 - 7 = 3
    mov r0, #7
    rsb r0, r0, #10         @ R0 = 10 - 7 = 3
    
    @ Test 2: RSB with register - 12 - 7 = 5
    mov r1, #7
    mov r4, #12             @ Use r4 as temp to avoid clobbering
    rsb r1, r1, r4          @ R1 = 12 - 7 = 5
    
    @ Test 3: RSB negative result - 3 - 5 = -2
    mov r4, #5
    mov r5, #3
    rsb r2, r4, r5          @ R2 = 3 - 5 = -2 = 0xFFFFFFFE
    
    @ Test 4: RSB - 10 - 8 = 2
    mov r4, #8
    mov r5, #10
    rsb r3, r4, r5          @ R3 = 10 - 8 = 2

    bkpt #0
