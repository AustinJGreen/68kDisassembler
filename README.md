# 68k Disassembler
Disassembles 68k machine code into readable 68k opcode instructions.

## Quick Links
- [68k Manual](https://www.nxp.com/files-static/archives/doc/ref_manual/M68000PRM.pdf)
- [68k OpCode Cheat Sheet](http://goldencrystal.free.fr/M68kOpcodes-v2.3.pdf)
- [EASy68k Quick Reference](http://www.easy68k.com/files/EASy68KQuickRef.pdf)

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

## Project Status
- [X] Setup github
- [X] Create disassembler and testing files
- [X] Read memory

## Op-Codes Supported
- [X] NOP
- [ ] MOVE
- [ ] MOVEA
- [ ] MOVEQ
- [ ] MOVEM
- [ ] ADD
- [ ] ADDA
- [ ] ADDQ
- [ ] SUB
- [ ] MULS
- [ ] DIVU
- [ ] LEA
- [ ] AND
- [ ] OR
- [X] NOT
- [ ] LSL
- [ ] LSR
- [ ] ASR
- [ ] ASL
- [ ] BGT
- [ ] BLE
- [ ] BEQ
- [X] JSR
- [X] RTS
- [ ] BRA
