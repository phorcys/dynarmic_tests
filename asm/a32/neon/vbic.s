/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00ff00ff00ff00ff00ff00ff00ff00ff",
    "Q1": "0xffffffffffffffffffffffffffffffff",
    "Q2": "0x00000000000000000000000000000000"
  }
}
*/
.text
.global _start
_start:
    @ VBIC: Vector Bitwise Clear (AND with complement)
    @ Q2 = Q0 AND (NOT Q1)
    vmov.i16 q0, #0xFF    @ Q0 = 0x00FF per 16-bit element
    vmov.i8 q1, #0xFF     @ Q1 = 0xFF per 8-bit element = all 1s
    vbic q2, q0, q1       @ Q2 = Q0 AND (NOT Q1) = Q0 AND 0 = 0
    bkpt #0