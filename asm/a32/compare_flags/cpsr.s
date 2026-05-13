/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000010" }
}
*/
.text
.global _start
_start:
    // MRS: Move PSR to ARM register
    // Extract mode bits from CPSR
    
    mrs r0, cpsr
    and r0, r0, #0x1F   // Extract mode bits (should be 0x10 for User mode)
    
    bkpt #0
