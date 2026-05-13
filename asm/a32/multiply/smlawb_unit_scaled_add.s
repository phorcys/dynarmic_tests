/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000003" }
}
*/
.text
.global _start
_start:
    mov r1, #1
    lsl r1, r1, #16
    mov r2, #3
    mov r3, #0
    smlawb r0, r1, r2, r3
    bkpt #0
