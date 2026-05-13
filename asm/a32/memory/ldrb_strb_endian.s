/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000078",
    "R1": "0x00000056",
    "R2": "0x00000034",
    "R3": "0x00000012"
  }
}
*/
// Test: LDRB/STRB - byte load/store

.text
.arm
.global _start
_start:
    sub sp, sp, #16
    
    @ Store a word
    ldr r0, =0x12345678
    str r0, [sp]
    
    @ Load individual bytes (little-endian)
    ldrb r0, [sp, #0]       @ r0 = 0x78 (LSB)
    ldrb r1, [sp, #1]       @ r1 = 0x56
    ldrb r2, [sp, #2]       @ r2 = 0x34
    ldrb r3, [sp, #3]       @ r3 = 0x12 (MSB)
    
    add sp, sp, #16
    bkpt #0
