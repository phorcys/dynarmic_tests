/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0xFFFFFFFF",
    "R2": "0x00000003",
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
    mvn r5, #0
    adc r0, r5, #0

    cmp r4, #1
    adc r1, r5, #0

    cmp r4, #0
    mov r2, #1
    adc r2, r2, r2

    ldr r6, =0x7FFFFFFF
    adc r3, r6, #0

    bkpt #0
