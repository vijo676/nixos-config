# NixOS configurations
Mainly used for consistent configurations and portability from machine to machine with as few changes as possible.

## Repository Structure

```md
📂 hosts/                                   # Host configurations
├──📁<host_machine_name>/                   # Specific hardware and host configuration
├──📁modules/                               # Contains all the nix derivation for modules that hosts can enable
|   ├──📂editors/                           # Contains derivations for different editors
|   ├──📂programs/                          # Contains derivations for programs aswell as their configurations
|   ├──📂shells/
|   ├──📂terminals/
|   └──️❄️️️default.nix                        # Nix derivation to propagate the nix derivations
├──💻.envrc/                                # Used to automaticlly load you into our default development shell
└──❄️flake.nix                              # The repos flake.nix, declaring all the nix inputs to the repo and all outputs that the repo provides
```