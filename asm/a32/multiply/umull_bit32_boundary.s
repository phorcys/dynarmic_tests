/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000", "R1": "0x00000001" }
}
*/
.text
.global _start
_start:
    mov r2, #1
    lsl r2, r2, #16
    mov r3, #1
    lsl r3, r3, #16
    umull r0, r1, r2, r3
    bkpt #0
