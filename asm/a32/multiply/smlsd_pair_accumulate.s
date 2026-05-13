/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005", "R1": "0x00020003", "R2": "0x00010002", "R3": "0x00000001" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00020003
    ldr r2, =0x00010002
    mov r3, #1
    smlsd r0, r1, r2, r3
    bkpt #0
.pool
