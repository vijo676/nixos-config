{
  lib,
  config,
  username,
  ...
}: let
  module_name = "yazi";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Yazi FileManager";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.yazi = {
        enable = true;
        settings = {
          manager = {
            show_hidden = true;
            show_symlink = true;
            linemode = "permissions";
            title_format = "";
          };
        };
      };
    };
  };
}
