/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x0": "0xDEADBEEF"
  },
  "SvcTest": [
    {"svc": "0x10", "action": "read_tls", "offset": "0x0", "result_reg": "R2"}
  ],
  "RegData": {
    "R2": "0xDEADBEEF"
  }
}
*/
.text
.arm
.global _start
_start:
    svc #0x10
    bkpt #0
