# 68k Disassembler
[![Ebert](https://ebertapp.io/badges/952t17QSexgENbUMPPvdie3m.svg)](https://ebertapp.io/github/ajosg/68kDisassembler)

Disassembles 68k machine code into readable 68k opcode instructions.

## Quick Links
- [68k Manual](https://www.nxp.com/files-static/archives/doc/ref_manual/M68000PRM.pdf)
- [68k OpCode Cheat Sheet](http://goldencrystal.free.fr/M68kOpcodes-v2.3.pdf)
- [EASy68k Quick Reference](http://www.easy68k.com/files/EASy68KQuickRef.pdf)
- [EASy68k Assembler Directives](http://lux.dmcs.pl/pn/asembler_68000/asm.html#tth_sEc4)

## Setting up the 68k Editor
Lets make sure we are all using the same settings for editing so we don't bother each other and the code stays uniform.
Make sure your EASy68K editor complies with the following: (Options -> Editor Options)

- Check Auto Indent
- Check Real Tabs
- Fixed Tab Size set to 4
- Fixed Tabs Checked

## Editing (Code) Style guidelines
- When commenting a line, always use a ; even if its at the end of the line so everything is straightforward
- Keep all code that performs a single task grouped together, use a newline for a new step in logic
- If writing a function, tell everyone what the function does and what registers you are using.
- Make sure all your LABELS are UPPERCASE.

## Op-Codes Supported
- [X] NOP
- [X] MOVE
- [X] MOVEA
- [X] MOVEQ
- [X] MOVEM
- [X] ADD
- [X] ADDA
- [X] ADDQ
- [X] SUB
- [X] MULS
- [X] DIVU
- [X] LEA
- [X] AND
- [X] OR
- [X] NOT
- [X] LSL
- [X] LSR
- [X] ASR
- [X] ASL
- [X] BGT
- [X] BLE
- [X] BLT
- [X] BEQ
- [X] JSR
- [X] RTS
- [X] BRA
