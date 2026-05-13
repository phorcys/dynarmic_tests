/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000004", "R1": "0x00000002" }
}
*/
.text
.global _start
_start:
    @ SMLAL accumulate carry basic sample
    
    mov r0, #4           @ Low accumulator
    mov r1, #1           @ High accumulator (bit 32 set means negative if signed)
    ldr r2, =0x10000
    ldr r3, =0x10000
    
    smlal r0, r1, r2, r3   @ r1:r0 += 65536 * 65536 = 4294967296
    @ r1:r0 = 0x100000004 + 0x100000000 = 0x200000004? No wait
    @ Actually: r1:r0 starts as (1 << 32) | 4 = 4294967300
    @ Add 65536 * 65536 = 4294967296
    @ Result = 8589934596 = 0x200000004
    @ r0 = 4, r1 = 2
    
    bkpt #0
.ltorg
