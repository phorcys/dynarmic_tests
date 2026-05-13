/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x40400000",
    "S1": "0x40800000",
    "S2": "0x40400000",
    "S3": "0x40800000",
    "X4": "0x0000000000000000"
  }
}
*/
// Test: FCSEL - floating-point conditional select
// FCSEL Sd, Sn, Sm, cond - if cond then Sd=Sn else Sd=Sm

.text
.global _start
_start:
    fmov s0, #3.0       // 0x40400000
    fmov s1, #4.0       // 0x40800000
    
    // Test 1: condition true (equal)
    fcmp s0, s0         // compare 3.0 with 3.0 -> equal, Z=1
    fcsel s2, s0, s1, eq   // if equal, s2 = s0 (3.0), else s1
    
    // Test 2: condition false (not equal)
    fcmp s0, s1         // compare 3.0 with 4.0 -> less, N=1
    fcsel s3, s0, s1, eq   // if equal, s3 = s0, else s1 (4.0)
    
    mov x4, #0
    brk #0
