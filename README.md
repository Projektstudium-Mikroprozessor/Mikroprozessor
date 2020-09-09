# Super32 - Designing our own Microprocessor

This repository contains the source code for a simple educational processor written in VHDL.

Software Tools (emulator, assembler, ...) for the Super32 processor are also available [here](https://github.com/Projektstudium-Mikroprozessor/Super32).

# Architecture

- RISC architecture
- Word size: 32 bit
- 32 registers
  - R0-R29: general purpose registers
  - R30: Constant 0 (can be written but without any effect)
  - R31: Constant 1 (can be written but without any effect)
- Fixed width instructions (32 bit) using 3-operand design
  - Arithmetic: `ADD`, `SUB`
  - Logical: `AND`, `OR`, `NOR`, `NAND`
  - Shift: `SHL`, `SAR`, `SLR`
  - Load/store: `LI`, `LW`, `SW`
  - Branch: `BEQ`
- 5-stage pipeline
  - `FE`: Fetch the instruction from memory
  - `DE`: Decode the instruction & read needed registers
  - `EX`: Do any necessary calculation
  - `MEM`: Read from / write to memory
  - `WB`: Write result to a register
- Distinct instruction & data memory (ROM & RAM)

## Instruction encoding

### Arithmetic / logical

*`OP`* *rd*, *r1*, *r2* \
*rd* = *r1* *`OP`* *r2*

```
| 0x0 (31:26) | r1 (25:21) | r2 (20:16) | rd (15:11) | XXX | func (3:0) |
```

| OP     | func | Description                                        |
|--------|------|----------------------------------------------------|
| `ADD`  | 0000 | Addition                                           |
| `SUB`  | 0010 | Subtraction                                        |
| `AND`  | 0100 | Bitwise AND                                        |
| `OR`   | 0101 | Bitwise OR                                         |
| `NAND` | 1011 | Bitwise NAND                                       |
| `NOR`  | 1010 | Bitwise NOR                                        |
| `SHL`  | 1100 | Shift left                                         |
| `SLR`  | 1110 | Shift right (logical, fill with `0`)               |
| `SAR`  | 1111 | Shift right (arithmetic, fill with `MSB`/sign bit) |

### Load / store

`LI` *rd*, *imm*(*r1*) \
*rd* = *r1* + *imm*

`LW` *rd*, *off*(*r1*) \
*rd* = MEM(*r1* + *off*)

`SW` *rs*, *off*(*r1*) \
MEM(*r1* + *off*) = *rs*

```
| opcode (31:26) | r1 (25:21) | rd/rs (20:16) | imm/off (15:0) |
```

| OP   | opcode | Description    |
|------|--------|----------------|
| `LI` | 000011 | Load immediate |
| `LW` | 100011 | Load word      |
| `SW` | 101011 | Save word      |

### Branch

`BEQ` *r1*, *r2*, *off* \
Advance next instruction *off* instructions if *r1* is equal to *r2* (`-1` is current instruction)

```
IF r1 == r2 THEN
  PC += 4 * off  # * 4 because 32-bit instructions
ENDIF
```

```
| 0x4 (31:26) | r1 (25:21) | r2 (20:16) | off (15:0) |
```

| OP    | Description     |
|-------|-----------------|
| `BEQ` | Branch if equal |

## Starting & resetting

Initially the processor is in a compeletly undefined state. Therefore upon powering on the processor must be reset by raising the `reset` signal to a logical 1 state.

### Processor reset

The processor can be reset at any time, during power-up or during execution, by raising the `reset` signal to a logical 1 state. This resets the processor to a predefined state:

- Control unit is reset (internal control signals, stage buffers)
- Pipeline is flushed (filled up with `NOP`s)
- Program Counter `PC` is reset to `0x0`
- Everything else MUST be considered undefined following a reset

## Pipeline conflicts

Pipeline conflicts are automatically recognized by the control unit and resolved by stalling (pushing & execution `NOP`s)

# Software integration

Using the software tools (the emulator) it is possible to export the assembled code as a `.vhdl` file, which can be used to setup the memory of this VHDL implementation.

Step-by-step guide:
1. Write your program using the emulator
2. Simulate/emulate the program to verify its functionality
3. Export the assembled machine code as a `.vhdl` file
4. Add the exported file to this project (`src/` folder)
5. Change the `memory` and `rom` entities in the `ucontroller.vhdl` (see below, insert the name you exported the code as):
6. Compile and simulate the VHDL code, for example using the provided `testbench.vhdl`

```
memory: ENTITY work.memory_<NAME> PORT MAP (
    ...
);
        
rom: ENTITY work.rom_<NAME> PORT MAP (
    ...
);
```
