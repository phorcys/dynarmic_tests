/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x80000001",
    "R2": "0x0FF0FF0F",
    "R3": "0xFFFFFFFF"
  }
}
*/
.text
.arm
.global _start
_start:
    mvn r4, #0
    eor r0, r4, r4

    ldr r4, =0x80000000
    eor r1, r4, #1

    ldr r2, =0x0F0F0F0F
    ldr r5, =0x00FFF000
    eor r2, r2, r5

    ldr r3, =0xAAAAAAAA
    eor r3, r3, r3, lsr #1

    bkpt #0
