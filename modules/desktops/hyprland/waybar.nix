{pkgs, ...}:{
  programs.waybar = {
    enable = true;
    settings = {
      position = "top";
      layer = "top";
      modules-left = [
        "wlr/workspaces"
      ];
    };
  };
}
