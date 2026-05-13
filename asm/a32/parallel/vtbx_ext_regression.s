/* CONFIG
{
  "Match": "All",
  "VecData": {
    "D0": "0x4E6E59B54F302913",
    "D1": "0xFED39DBB67804ED0",
    "D2": "0xFE6127BA3E645BF7",
    "D3": "0x0F8D3466F3C1B356"
  }
}
*/
.text
.syntax unified
.fpu neon-vfpv4
.arm
.global _start
_start:
    ldr r0, =table0
    vldr d0, [r0]
    ldr r0, =table1
    vldr d1, [r0]
    ldr r0, =dest0
    vldr d2, [r0]
    ldr r0, =index0
    vldr d3, [r0]

    vtbx.8 d2, {d0-d1}, d3
    bkpt #0

    .align 3
 table0:
    .word 0x4F302913, 0x4E6E59B5
 table1:
    .word 0x67804ED0, 0xFED39DBB
 dest0:
    .word 0x3E645BF7, 0x876127BA
 index0:
    .word 0xF3C1B356, 0x0F8D3466
