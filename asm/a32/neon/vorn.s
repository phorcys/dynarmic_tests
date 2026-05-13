/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x000000ff000000ff000000ff000000ff",
    "Q1": "0x0000000f0000000f0000000f0000000f",
    "Q2": "0xffffffffffffffffffffffffffffffff"
  }
}
*/
.text
.global _start
_start:
    @ VORN: Vector Bitwise OR NOT
    @ Q2 = Q0 OR (NOT Q1)
    vmov.i32 q0, #0xFF    @ Q0 = 0x000000FF per 32-bit element
    vmov.i32 q1, #0xF     @ Q1 = 0x0000000F per 32-bit element
    vorn q2, q0, q1       @ Q2 = 0xFF OR 0xFFFFFFF0 = 0xFFFFFFFF
    bkpt #0