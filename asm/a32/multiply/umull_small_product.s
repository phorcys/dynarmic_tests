/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00004E20", "R1": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r2, #100
    mov r3, #200
    umull r0, r1, r2, r3
    bkpt #0
