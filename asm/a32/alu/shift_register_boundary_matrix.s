/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000000",
    "R2": "0xFFFFFFFF",
    "R3": "0x80000001"
  }
}
*/
// Register-shift boundaries unique to A32 Operand2.

.text
.arm
.global _start
_start:
    mov r4, #1

    mov r5, #0
    lsl r0, r4, r5          @ shift by 0 => unchanged

    mov r5, #32
    lsr r1, r4, r5          @ register LSR by 32 => zero

    mov r5, #32
    mvn r6, #0
    asr r2, r6, r5          @ register ASR by 32 => all ones

    mov r5, #33
    mov r6, #3
    ror r3, r6, r5          @ rotate by 33 == rotate by 1

    bkpt #0
