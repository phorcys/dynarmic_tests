/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x80000001",
    "R2": "0x00000009",
    "R3": "0x00000000"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #1
    rsb r0, r0, #0

    ldr r1, =0x80000000
    rsb r1, r1, #1

    mov r2, #3
    rsb r2, r2, r2, lsl #2

    mov r3, #0
    rsb r3, r3, #0

    bkpt #0
