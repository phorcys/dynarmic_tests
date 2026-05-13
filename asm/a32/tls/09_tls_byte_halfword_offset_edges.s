/* CONFIG
{
  "Match": "All",
  "TpidrurwInit": "0x3000",
  "TlsData": {
    "0x4": ["0x00000080", "0x0000007f", "0x00001234"]
  },
  "RegData": {
    "R0": "0xFFFFFF80",
    "R1": "0x0000007F",
    "R2": "0x00001234",
    "R3": "0x00000004"
  }
}
*/
// TLS offset edges under the current runner's word-based TLS initialization.

.text
.arm
.global _start
_start:
    mrc p15, 0, r4, c13, c0, 2

    ldrsb r0, [r4, #4]
    ldrb r1, [r4, #8]
    ldrh r2, [r4, #12]

    add r3, r4, #4
    sub r3, r3, r4

    bkpt #0
