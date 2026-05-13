/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000004"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #0
    bl func_a
    ldr r1, =func_b
    blx r1
    bl func_c
    bl func_d
    bkpt #0

func_a:
    add r0, r0, #1
    bx lr

func_b:
    add r0, r0, #1
    bx lr

func_c:
    add r0, r0, #1
    bx lr

func_d:
    add r0, r0, #1
    bx lr
