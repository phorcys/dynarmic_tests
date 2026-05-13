/* CONFIG
{
  "Match": "All",
  "Bucket": "fuzz_cpsr",
  "SourceRepro": "batch_single_002/usax_cpsr_sample.json",
  "SetCpsr": "0x50000010",
  "SetFpscr": "0x07480000",
  "ExpectedCpsr": "0x500C0010",
  "ExpectedFpscr": "0x07400000",
  "SetRegData": {
    "R0": "0xD854FA5D",
    "R1": "0xF66D7B8C",
    "R2": "0xD3A330F3",
    "R3": "0xF188DE1E",
    "R4": "0x69E15E0C",
    "R5": "0xA96621E0",
    "R6": "0xB6C1F69B",
    "R7": "0xA0DA3D71",
    "R8": "0xAEEB6980",
    "R9": "0xEAEF67A5",
    "R10": "0x1A67D450",
    "R11": "0x6D7E52EF",
    "R12": "0x06843163",
    "SP": "0x6983BD9F",
    "LR": "0x8B9786B0"
  },
  "ExpectedRegData": {
    "R0": "0xD854FA5D",
    "R1": "0xF66D7B8C",
    "R2": "0xD3A330F3",
    "R3": "0xF188DE1E",
    "R4": "0x69E15E0C",
    "R5": "0xA96621E0",
    "R6": "0xB6C1F69B",
    "R7": "0xA0DA3D71",
    "R8": "0xAEEB6980",
    "R9": "0xEAEF67A5",
    "R10": "0x1A67D450",
    "R11": "0x9861E56D",
    "R12": "0x06843163",
    "SP": "0x6983BD9F",
    "LR": "0x8B9786B0"
  }
}
*/
.text
.arm
.global _start
_start:
    .word 0xE651BF54
    bkpt #0
