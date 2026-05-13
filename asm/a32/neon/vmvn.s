/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0xffffffffffffffffffffffffffffffff",
    "Q1": "0x00000000000000000000000000000000"
  }
}
*/
.text
.global _start
_start:
    @ VMVN: Vector Bitwise NOT
    @ Q1 = NOT Q0
    vmov.i8 q0, #0xFF
    vmvn q1, q0
    bkpt #0