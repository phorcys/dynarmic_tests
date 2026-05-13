/* CONFIG
{
  "Match": "All",
  "SvcTest": [
    {"svc": "0x11", "action": "write_tls", "offset": "0x0", "result_reg": "R0"},
    {"svc": "0x10", "action": "read_tls", "offset": "0x0", "result_reg": "R2"}
  ],
  "RegData": {
    "R0": "0xCAFEBABE",
    "R2": "0xCAFEBABE"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r0, =0xCAFEBABE
    svc #0x11
    svc #0x10
    bkpt #0
