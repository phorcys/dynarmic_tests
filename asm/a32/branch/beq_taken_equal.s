/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000002A"
  }
}
*/
.text
.global _start
_start:
    mov r0, #5
    cmp r0, #5
    beq skip
    mov r0, #0
    b done
skip:
    mov r0, #42
done:
    bkpt #0
