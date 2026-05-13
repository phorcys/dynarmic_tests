/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000008",
    "R1": "0x00000000",
    "R2": "0x00000002",
    "R3": "0x00000003"
  }
}
*/
.text
.global _start
_start:
    mov r0, #1
    mov r1, #1
    mov r2, #2
    mov r3, #3
    umaal r0, r1, r2, r3
    bkpt #0
