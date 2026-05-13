/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x8000FFFF",
    "R2": "0x67452301",
    "R3": "0x23016745"
  }
}
*/
.text
.global _start
_start:
    mov r4, #0
    rev r0, r4

    ldr r4, =0x0080FFFF
    rev16 r1, r4

    ldr r4, =0x01234567
    rev r2, r4

    ldr r4, =0x01234567
    rev16 r3, r4

    bkpt #0
