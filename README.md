<h1 align="center">
   <img src="./.github/assets/nixos-logo.png  " width="100px" />
   <br>
      vijo676's nixOS config
   <br>

   <div align="center">
      <p></p>
      <div align="center">
         <a = href="https://nixos.org">
            <img src="https://img.shields.io/badge/NixOS-25.05-blue.svg?style=for-the-badge&labelColor=282828&logo=NixOS&logoColor=458588&color=458588">
         </a>
         <a href="https://github.com/Frost-Phoenix/nixos-config/blob/main/LICENSE">
            <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&colorA=282828&colorB=98971A&logo=unlicense&logoColor=98971A&"/>
         </a>
      </div>
      <br>
   </div>
</h1>

# Overview

Mainly used for consistent configurations and portability. `flake.nix` is the base of the configuration. Uses `Home-Manager` for user-specific configurations and `NixOS modules` for system-wide settings.

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