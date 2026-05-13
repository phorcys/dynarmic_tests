/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0xFFFFFFFE",
    "R2": "0x00000000",
    "R3": "0x7FFFFFFF"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r4, #0
    cmp r4, #0
    mov r0, #0
    sbc r0, r0, #1

    cmp r4, #1
    mov r1, #0
    sbc r1, r1, #1

    cmp r4, #0
    mov r2, #5
    sbc r2, r2, #5

    ldr r3, =0x80000000
    sbc r3, r3, #1

    bkpt #0
