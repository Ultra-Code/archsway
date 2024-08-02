# River Configurator

## Zig

Build the zig river configurator with the command below

`zig build-exe -Doptimize=ReleaseFast -fstrip init.zig`

Remove the residue object file generated

`rm init.o`

## Luajit

To use the luajit configurator, copy the init.lua

`cp init.lua init`

Make the script executable

`chmod +x init`
