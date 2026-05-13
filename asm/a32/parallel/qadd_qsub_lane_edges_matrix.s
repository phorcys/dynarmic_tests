/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFF7FFF",
    "R1": "0x80008000",
    "R2": "0x00100020",
    "R3": "0x00000010"
  }
}
*/
// A32 parallel saturating arithmetic edges.

.text
.arm
.global _start
_start:
    ldr r4, =0x70007000
    ldr r5, =0x10001000
    qadd16 r0, r4, r5       @ saturate both halfwords to 0x7FFF

    ldr r4, =0x80018000
    mov r5, #1
    orr r5, r5, #0x00010000
    qsub16 r1, r4, r5       @ underflow both halfwords to 0x8000

    ldr r4, =0x00100010
    ldr r5, =0x00000010
    qadd8 r2, r4, r5        @ lane-local no-saturate mix

    ldr r4, =0x00000020
    ldr r5, =0x00000010
    qsub8 r3, r4, r5        @ low byte 0x10, others zero

    bkpt #0
