/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "D0": "0x4040000040400000",
    "R0": "0x00000005",
    "R1": "0x00000005"
  }
}
*/
.text
.global _start
_start:
    vmov.f32 s0, #3.0
    vmov.f32 s1, s0      // S1 = S0 (S1 is D0 high)
    
    mov r0, #5
    mov r1, r0           // R1 = R0
    
    bkpt #0
