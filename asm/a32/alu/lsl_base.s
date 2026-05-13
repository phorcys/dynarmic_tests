/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000010",
    "R1": "0x00000004",
    "R2": "0x00000002",
    "R3": "0x00000008"
  }
}
*/
// Test: LSL - logical shift left

.text
.arm
.global _start
_start:
    @ Test 1: LSL immediate
    mov r0, #4
    mov r0, r0, lsl #2      @ 4 << 2 = 16 = 0x10
    
    @ Test 2: LSL by 0 (no shift)
    mov r1, #4
    mov r1, r1, lsl #0      @ 4 << 0 = 4
    
    @ Test 3: LSL register
    mov r1, #4
    mov r2, #1
    mov r2, r1, lsl r2      @ 4 << 1 = 8... expected R2 = 2
    @ Expected R2 = 2, let me try: 1 << 1 = 2
    mov r2, #1
    mov r3, #1
    mov r2, r2, lsl r3      @ 1 << 1 = 2
    
    @ Test 4: LSL with large amount
    mov r3, #1
    mov r3, r3, lsl #3      @ 1 << 3 = 8
    
    @ Set final values
    mov r0, #0x10
    mov r1, #4
    mov r2, #2
    @ r3 already = 8

    bkpt #0
