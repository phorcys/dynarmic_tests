/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000008",
    "R1": "0x00000004",
    "R2": "0x00000002",
    "R3": "0x00000001"
  }
}
*/
// Test: LSR - logical shift right

.text
.arm
.global _start
_start:
    @ Test 1: LSR immediate - 16 >> 1 = 8
    mov r0, #16
    mov r0, r0, lsr #1
    
    @ Test 2: LSR by multiple positions - 16 >> 2 = 4
    mov r4, #16
    mov r1, r4, lsr #2
    
    @ Test 3: LSR register - 8 >> 2 = 2
    mov r4, #8
    mov r5, #2
    mov r2, r4, lsr r5
    
    @ Test 4: LSR shifts out all bits - 8 >> 3 = 1
    mov r4, #8
    mov r3, r4, lsr #3
    
    bkpt #0
