/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000002",
    "R1": "0x80000001",
    "R2": "0x12345678"
  }
}
*/
// MRRC should read the exact two 32-bit words from the coprocessor accessors
// without assuming the pointers are adjacent in host memory.

.text
.arm
.global _start
_start:
    mrrc p15, #0, r1, r2, c0
    add r0, r1, #1
    bkpt #0
