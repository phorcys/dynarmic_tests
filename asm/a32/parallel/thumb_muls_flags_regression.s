/* CONFIG
{
  "Match": "All",
  "Bucket": "fuzz_cpsr",
  "SourceRepro": "0x4348_sample.json",
  "SetCpsr": "0xA00001F0",
  "SetFpscr": "0x02480000",
  "ExpectedCpsr": "0x200001F0",
  "ExpectedFpscr": "0x02400000",
  "SetRegData": {
    "R0": "0xDA8225BA",
    "R1": "0x90C2ED93",
    "R2": "0x887598D8",
    "R3": "0x877A2A66",
    "R4": "0xFAD40E5A",
    "R5": "0xF0F4BB2F",
    "R6": "0xE666C1A1",
    "R7": "0xEC7BD962",
    "R8": "0xB758E3AD",
    "R9": "0x8B041CEC",
    "R10": "0x01E5A74E",
    "R11": "0x3C3543EE",
    "R12": "0xF8E4B798",
    "SP": "0x2D51D90A",
    "LR": "0x554819F5"
  },
  
  "ExpectedRegData": {
    "R0": "0x2C9CDBCE",
    "R1": "0x90C2ED93",
    "R2": "0x887598D8",
    "R3": "0x877A2A66",
    "R4": "0xFAD40E5A",
    "R5": "0xF0F4BB2F",
    "R6": "0xE666C1A1",
    "R7": "0xEC7BD962",
    "R8": "0xB758E3AD",
    "R9": "0x8B041CEC",
    "R10": "0x01E5A74E",
    "R11": "0x3C3543EE",
    "R12": "0xF8E4B798",
    "SP": "0x2D51D90A",
    "LR": "0x554819F5"
  }
}
*/
.text
.thumb
.global _start
_start:
    .hword 0x4348
    bkpt #0
