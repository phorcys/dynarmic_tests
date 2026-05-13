/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000002B",
    "R1": "0x0000002B",
    "R2": "0x00000003"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #40
    bl add_three
    mov r1, r0
    bkpt #0

add_three:
    add r0, r0, #3
    mov r2, #3
    bx lr
