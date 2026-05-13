/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFF0000FF" }
}
*/
.text
.global _start
_start:
    @ BFC: clear middle 16-bit field
    @ BFC Rd, #lsb, #width
    
    mvn r0, #0           @ R0 = 0xFFFFFFFF
    
    bfc r0, #8, #16      @ Clear bits [23:8]
    
    bkpt #0
