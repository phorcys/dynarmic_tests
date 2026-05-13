/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000011",
    "R1": "0x00000022",
    "R2": "0x00000033",
    "R3": "0x00000044"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r4, =stage1
    bx r4

stage1:
    mov r0, #0x11
    ldr r4, =stage2
    bx r4

stage2:
    mov r1, #0x22
    ldr r4, =stage3
    bx r4

stage3:
    mov r2, #0x33
    ldr r4, =stage4
    bx r4

stage4:
    mov r3, #0x44
    bkpt #0

.align 4
