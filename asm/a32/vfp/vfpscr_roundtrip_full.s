/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R1": "0xF840001F"
  }
}
*/
.text
.arm
.global _start
_start:
    // Writable subset chosen to match current A32 FPSCR architectural model:
    // NZCV[31:28] = 0xF
    // QC[27] = 1
    // RMode[23:22] = 01 (RUP)
    // Exception flags[4:0] = 0x1F
    ldr r0, =0xF840001F
    vmsr fpscr, r0
    vmrs r1, fpscr

    bkpt #0
