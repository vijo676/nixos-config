# NixOS configurations
Mainly used for consistent configurations and portability from machine to machine with as few changes as possible.

## Repository Structure

```md
📂nixOS-config/
├──📁hosts/                         # Hosts configurations
├──📁home/                          # Home-Manager modules
├──📁modules/                       # NixOS modules
├──📁wallapapers/                   # Wallpapers png,jpg etc.
├──💻.envrc
└──❄️flake.lock
└──❄️flake.nix
```

## Getting Started

1. **Clone this repository:**
   ```sh
   git clone https://github.com/yourusername/NixOS-config.git
   cd NixOS-config
   ```

2. **Switch to a host configuration:**
   ```sh
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

3. **Apply home-manager configuration:**
   ```sh
   home-manager switch --flake .#<hostname>
   ```