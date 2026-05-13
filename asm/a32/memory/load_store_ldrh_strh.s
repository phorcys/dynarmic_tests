/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00001234", "R1": "0x00005678" }
}
*/
.text
.global _start
_start:
    // LDRH/STRH: Load/Store Halfword
    sub sp, sp, #8

    @ Store halfwords
    mov r0, #0x1234
    mov r1, #0x5678
    strh r0, [sp, #0]
    strh r1, [sp, #2]

    @ Load halfwords back
    ldrh r0, [sp, #0]   @ R0 = 0x1234
    ldrh r1, [sp, #2]   @ R1 = 0x5678

    bkpt #0
