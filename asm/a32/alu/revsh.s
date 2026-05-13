/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00003412" }
}
*/
.text
.global _start
_start:
    @ REVSH: Reverse bytes in lower halfword and sign extend
    @ R0 = revsh(R1) - reverse bytes in R1[15:0], sign extend to 32 bits
    ldr r1, =0x00001234
    revsh r0, r1
    bkpt #0
.ltorg