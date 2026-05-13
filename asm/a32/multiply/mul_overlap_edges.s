/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000019",
    "R1": "0xFFFFFFF8",
    "R2": "0x00000000",
    "R3": "0x00010000"
  }
}
*/
.text
.global _start
_start:
    mov r0, #5
    mul r0, r0, r0         @ self-overlap: 25

    mov r1, #-2
    mov r4, #4
    mul r1, r1, r4         @ -8

    mov r2, #0
    mov r4, #123
    mul r2, r2, r4         @ zero result

    ldr r3, =0x00000100
    ldr r4, =0x00000100
    mul r3, r3, r4         @ 0x10000

    bkpt #0
