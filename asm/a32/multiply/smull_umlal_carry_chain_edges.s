/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000000",
    "R1": "0x00000000",
    "R2": "0x80000001",
    "R3": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x40000000
    mov r5, #2
    smull r0, r1, r4, r5

    mov r2, #1
    mov r3, #0
    umlal r2, r3, r4, r5

    bkpt #0
