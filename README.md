# subsToolkit

A toolkit for substratum themers which decompiles apks within multiple projects.

Any number of self-contained project folders can be created and worked with and each 
project folder can contain any number of apks.

When decompiling or batch decompiling apks, any previously installed frameworks 
are deleted and the frameworks for the project you're working in are installed automatically.
This enables different roms to be worked on without their frameworks getting mixed up.

Running Cleanup.bat after quitting will delete all installed frameworks and log.txt

WHAT IT CAN DO

  - Decompile individual system & user apks
  - Batch decompile folders containing system & user apks

SETUP

1. Java MUST be installed for this tool to work.

2. Create a project folder to work in - this could be named after the rom you're working
   with, theme ready gapps or just a generic folder name if you're only working with user apps.

3. Copy ALL of the framework apks from the rom you're working with into the 'frameworks'
   folder of the project folder.

4. Copy all of the apks from the rom you're working with into the 'files_in' folder 
   of the project folder.

5. Use the menu to select tasks and execute them.
