/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000042",
    "R1": "0x00000039",
    "R2": "0x0000000C",
    "R3": "0x00001003",
    "R4": "0x00000005"
  }
}
*/
.text
.global _start
_start:
    @ ADD immediate - simple
    mov r0, #33
    add r0, r0, #33      @ r0 = 33 + 33 = 66 = 0x42
    
    @ ADD registers
    mov r1, #20
    mov r5, #25
    add r1, r1, r5       @ r1 = 20 + 25 = 45 = 0x2D... wait, let me check
    @ Actually 20+25=45=0x2D, but expected is 0x39=57
    @ Let me use 32+25=57=0x39
    mov r1, #32
    add r1, r1, r5       @ r1 = 32 + 25 = 57 = 0x39
    
    @ ADD with shift
    mov r2, #4
    add r2, r2, r2, LSL #1  @ 4 + (4 << 1) = 4 + 8 = 12 = 0xC
    
    @ ADD with immediate 12-bit (valid ARM immediate)
    mov r3, #3
    add r3, r3, #4096    @ 3 + 4096 = 4099 = 0x1003
    
    @ ADD with different registers
    mov r4, #2
    add r4, r4, #3       @ 2 + 3 = 5
    
    bkpt #0