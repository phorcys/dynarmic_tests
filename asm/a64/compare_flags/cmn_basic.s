/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  },
  "NZCV": "0x00000006"
}
*/
// CMN basic

.text
.global _start
_start:
    mov x0, #5
    cmn x0, #5            // 5 + 5 = 10, Z=0 (not zero), but we're checking for 0
    // Actually CMN x0, #5 compares x0 with -5
    // 5 - (-5) = 10, which is != 0, so Z=0
    // Wait, CMN is "compare negative": x0 + imm, sets flags
    // CMN x0, #5: compute x0 + 5, set flags
    // If x0 = -5, then -5 + 5 = 0, Z=1
    mov x0, #-5
    cmn x0, #5            // -5 + 5 = 0, Z=1
    cset x0, eq
    brk #0
