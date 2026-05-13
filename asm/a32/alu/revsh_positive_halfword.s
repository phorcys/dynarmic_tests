/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x000001FF", "R2": "0x000001FF" }
}
*/
.text
.global _start
_start:
    mov r1, #0xFF
    lsl r1, r1, #8
    orr r1, r1, #0x01
    revsh r0, r1

    mov r2, r1
    revsh r2, r2

    bkpt #0
