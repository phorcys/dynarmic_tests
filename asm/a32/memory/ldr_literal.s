/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005" }
}
*/
.text
.global _start
_start:
    @ PC-relative load
    @ Use ADR to get address
    
    ldr r0, my_value
    
    bkpt #0
    
my_value:
    .word 5