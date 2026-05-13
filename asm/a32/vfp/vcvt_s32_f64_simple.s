/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000", "R1": "0x40140000" }
}
*/
.text
.global _start
_start:
    @ VCVT.F64.S32: Convert signed int to double
    @ VCVT.F64.S32 Dd, Sm
    
    mov r0, #5
    vmov s0, r0             @ S0 = 5
    
    vcvt.f64.s32 d1, s0     @ D1 = (double)5 = 5.0
    
    vmov r0, r1, d1         @ R0:R1 = D1 (low:high)
    
    bkpt #0
