/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005", "R1": "0x00000005" }
}
*/
.text
.global _start
_start:
    @ VMOV: Move between ARM register and VFP register
    @ VMOV.32 Rt, Dn[x]
    
    mov r0, #5
    vmov s0, r0             @ Move r0 to s0
    
    vmov r1, s0             @ Move s0 to r1
    
    bkpt #0
.ltorg
