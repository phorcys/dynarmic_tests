/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "Q0": "0x0000000F0000000F0000000F0000000F",
    "Q1": "0x000000F0000000F0000000F0000000F0",
    "Q2": "0x000000FF000000FF000000FF000000FF"
  }
}
*/
.text
.global _start
_start:
    // Q0 = [15, 15, 15, 15] = 0x0F
    vmov.i32 q0, #15
    // Q1 = [240, 240, 240, 240] = 0xF0
    vmov.i32 q1, #240
    
    // Q2 = Q0 | Q1 = [255, 255, 255, 255]
    vorr q2, q0, q1
    
    bkpt #0