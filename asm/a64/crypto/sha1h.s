/* CONFIG
{
  "Match": "All",
  "S0": "0x048D159E"
}
*/
// Test: SHA1H Sd, Sn - SHA1 fixed rotate
// Rotates the 32-bit value right by 2 bits

.text
.global _start
_start:
    // s0 = 0x12345678
    mov w0, #0x5678
    movk w0, #0x1234, lsl #16
    fmov s0, w0
    
    // SHA1H: rotate right by 2
    // 0x12345678 ROR 2 = 0x48D159E2
    sha1h s0, s0
    
    brk #0