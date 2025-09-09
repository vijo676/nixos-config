{
  pkgs,
  lib,
  config,
  ...
}:
let
  module_name = "starship";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Starship";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$os"
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$package"
          "$c"
          "$cmake"
          "$python"
          "$rust"
          "$zig"
          "$nix_shell"
          "$character"
        ];

        add_newline = true;
        palette = "everforest";

        os = {
          disabled = true;
          format = "[$symbol ]($style)";
          style = "fg:grey2";
          symbols = {
            Windows = "󰍲";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "󰀵";
            Manjaro = "";
            Linux = "󰌽";
            Gentoo = "󰣨";
            Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "󰣇";
            Artix = "󰣇";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
          };
        };
        username = {
          disabled = false;
          format = "[$user]($style)";
          style_root = "fg:red";
          style_user = "fg:blue";
        };
        hostname = {
          disabled = false;
          format = "[$hostname]($style)";
          style = "fg:blue";
        };
        nix_shell = {
          symbol = "";
          format = "[$symbol $name]($style) ";
          style = "fg:nix_blue";
        };
        directory = {
          disabled = false;
          style = "fg:blue";
          read_only_style = "fg:blue";
          truncation_length = 3;
          truncation_symbol = "…/";
          format = "[ $path]($style)[$read_only]($read_only_style) ";
        };
        git_branch = {
          style = "fg:green";
          symbol = " ";
          format = "[$symbol$branch(:$remote_branch)]($style) ";
        };
        character = {
          success_symbol = "\n[➜](bold green)";
          error_symbol = "\n[➜](bold red)";
          vimcmd_symbol = "\n[➜](bold blue)"; # Block for vi normal mode
          vimcmd_replace_one_symbol = "\n[➜](bold yellow)"; # Block for replace mode
          vimcmd_replace_symbol = "\n[➜](bold purle)"; # Block for replace mode
          vimcmd_visual_symbol = "\n[➜](bold magenta)"; # Block for visual mode
        };
        palettes = {
          everforest = {
            bg_dim = "#232a2e";
            bg0 = "#2d353b";
            bg1 = "#343f44";
            bg2 = "#3d484d";
            bg3 = "#475258";
            bg4 = "#4f585e";
            bg5 = "#56635f";
            bg_visual = "#543a48";
            bg_red = "#514045";
            bg_green = "#425047";
            bg_blue = "#3a515d";
            bg_yellow = "#4d4c43";

            fg = "#d3c6aa";
            red = "#e67e80";

            orange = "#e69875";
            yellow = "#dbbc7f";
            green = "#a7c080";
            aqua = "#83c092";
            blue = "#7fbbb3";
            nix_blue = "#405D99";
            purple = "#d699b6";
            grey0 = "#7a8478";
            grey1 = "#859289";
            grey2 = "#9da9a0";
            statusline1 = "#a7c080";
            statusline2 = "#d3c6aa";
            statusline3 = "#e67e80";
          };
        };
      };
    };
  };
}
