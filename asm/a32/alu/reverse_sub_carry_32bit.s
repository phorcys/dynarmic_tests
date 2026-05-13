/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0xFFFFFFFE",
    "R2": "0x00000007",
    "R3": "0x80000000"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r4, #0
    cmp r4, #0
    mov r0, #1
    rsc r0, r0, #0

    cmp r4, #1
    mov r1, #1
    rsc r1, r1, #0

    cmp r4, #0
    mov r2, #7
    rsc r2, r2, r2, lsl #1

    ldr r3, =0x80000000
    rsc r3, r3, #0

    bkpt #0
