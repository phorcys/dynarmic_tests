/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x12345678" }
}
*/
.text
.global _start
_start:
    // LDR with PC-relative addressing
    ldr r0, =0x12345678    @ Load constant using literal pool
    bkpt #0
