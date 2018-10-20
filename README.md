# 68k Disassembler
Disassembles 68k machine code into readable 68k opcode instructions.

## Setting up the 68k Editor

Lets make sure we are all using the same settings for editing so we don't bother each other and the code stays uniform.
Make sure your EASy68K editor complies with the following: (Options -> Editor Options)

- Check Auto Indent
- Check Real Tabs
- Fixed Tab Size set to 4
- Fixed Tabs Checked 

## Setting up the project for editing

1. Make sure git is installed. Click [here](https://git-scm.com/downloads) to install git.
2. If you don't have one already, create a folder somewhere for all of your 68k Projects.
3. Open up commend prompt
4. Change directory to your 68k Projects folder.
5. Clone this project into that directory. `git clone https://github.com/ajosg/68kDisassembler.git`

## Editing (Code) Style guidelines

- When in doubt, comment the line so we are all on the same page.
- When commenting a line, always use a ; even if its at the end of the line so everything is straightforward
- Keep all code that performs a single task grouped together, use a newline for a new step in logic
- If writing a function, tell everyone what the function does and what registers you are using.
- Make sure all your LABELS are UPPERCASE. 

## Commiting your changes

- `git commit -m "Added some stuff."`

## Project Status

- [ ] Setup github
- [ ] Create disassembler and testing files
