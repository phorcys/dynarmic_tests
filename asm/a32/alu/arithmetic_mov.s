/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000002A",
    "R1": "0x00000000",
    "R2": "0xFFFFFFFF",
    "R3": "0xFFFFFF00",
    "R4": "0x000000FF"
  }
}
*/
.text
.global _start
_start:
    @ MOV immediate
    mov r0, #42
    
    @ MOV from register
    mov r1, #0
    
    @ MVN immediate
    mvn r2, #0
    
    @ MVN register
    mov r5, #0xFF
    mvn r3, r5
    
    @ MOV with shift
    mov r4, r5, LSL #0
    
    bkpt #0
