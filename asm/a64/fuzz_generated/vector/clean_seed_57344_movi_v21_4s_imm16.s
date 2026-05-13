/* CONFIG
{
  "Match": "All",
  "Bucket": "fuzz-clean/vector-materialization",
  "SourceRepro": "batch_5x100_clean seed=57344 single",
  "MaxTicks": "0x10",
  "SetPstate": "0x90000000",
  "SetFpcr": "0x02080000",
  "SetFpsr": "0x00000000",
  "ExpectedPstate": "0x90000000",
  "ExpectedFpcr": "0x02080000",
  "ExpectedFpsr": "0x00000000",
  "SetRegData": {
    "SP": "0x000000C6D201BBA4"
  },
  "SetVecData": {
    "V21": ["0xB465CEEC6E284E25", "0x72ACA1E981DC7C54"]
  },
  "ExpectedVecData": {
    "V21": ["0x002D0000002D0000", "0x002D0000002D0000"]
  }
}
*/

.text
.global _start
_start:
    // movi v21.4s, #0x2d, lsl #16
    .inst 0x4F0145B5
    brk #0
