# subsToolkit

A toolkit for substratum themers which can decompile individual system & user apks 
and/or batch decompile groups of system & user apks in multiple projects.

Java MUST be installed for this toolkit to work.

Any number of self-contained project folders can be created and worked with and each 
project folder can contain any number of apks.

When decompiling or batch decompiling apks, any previously installed frameworks 
are deleted and the frameworks for the project you're working in are installed automatically.
This enables different roms to be worked on without their frameworks getting mixed up.

Running Cleanup.bat after quitting will delete all installed frameworks and log.txt


# Using subsToolkit

1. Create a project folder to work in - this could be named after the rom you're working
   with, theme ready gapps or just a generic folder name if you're only working with user apps.

2. Copy ALL of the framework apks from the rom you're working with into the 'frameworks'
   folder of the project folder.

3. Copy all of the apks from the rom you're working with into the 'files_in' folder 
   of the project folder.

4. Use the menu to select tasks and execute them.
