/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFF8000",
    "R1": "0x80007FFF",
    "R2": "0x00040006",
    "R3": "0x00020002"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x7FFF8000
    ldr r5, =0x00018000
    qadd16 r0, r4, r5       @ hi: 32767+1 => sat 32767, lo: -32768 + -32768 => sat -32768

    ldr r4, =0x80007FFF
    ldr r5, =0x00018000
    qsub16 r1, r4, r5       @ hi: -32768-1 => sat -32768, lo: 32767-(-32768) => sat 32767

    ldr r4, =0x00010002
    ldr r5, =0x00030004
    qadd16 r2, r4, r5       @ 1+3, 2+4

    ldr r4, =0x00050006
    ldr r5, =0x00030004
    qsub16 r3, r4, r5       @ 5-3, 6-4

    bkpt #0
