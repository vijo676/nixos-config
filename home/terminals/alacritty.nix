{
  lib,
  config,
  ...
}: let
  module_name = "alacritty";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Alacritty";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          opacity = 0.55;
          decorations = "none";
        };
        font = {
          normal = {
            family = "CaskaydiaCove Nerd Font";
          };
          size = 12;
        };
        colors = {
          # Gruvbox Dark Hard theme colors
          primary = {
            background = "0x1d2021";
            foreground = "0xfbf1c7";
          };
          normal = {
            black = "0x1d2021";
            red = "0xcc241d";
            green = "0x98971a";
            yellow = "0xd79921";
            blue = "0x458588";
            magenta = "0xb16286";
            cyan = "0x689d6a";
            white = "0xa89984";
          };
          bright = {
            black = "0x928374";
            red = "0xfb4934";
            green = "0xb8bb26";
            yellow = "0xfabd2f";
            blue = "0x83a598";
            magenta = "0xd3869b";
            cyan = "0x8ec07c";
            white = "0xebdbb2";
          };
        };
        cursor = {
          style = "Block";
        };
        keyboard.bindings = [
        ];
      };
    };
    programs.eza = {
      enable = true;
      colors = "always";
      icons = "always";
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
