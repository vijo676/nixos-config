{
  pkgs,
  lib,
  config,
  ...
}:
let
  module_name = "tmux";
  cfg = config.configured.programs."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      baseIndex = 1;
      keyMode = "vi";
      prefix = "C-space";
      mouse = true;
      plugins = with pkgs.tmuxPlugins; [
        online-status
        vim-tmux-navigator
        yank
        resurrect
        continuum
        battery
        cpu
        prefix-highlight
        gruvbox
      ];
      extraConfig = ''
        # Enable true color
        set -g default-terminal "tmux-256color"
        set-option -ga terminal-overrides ",xterm-256color:Tc"

        # Enable focus events
        set -g focus-events on

        # Enable gapeless window
        set -g renumber-windows on

        set-option -g status-right ""
        set -g @continuum-restore 'on'
        set -g @continuum-boot 'on'

        set -g set-clipboard on
        set -g @override_copy_command 'xsel --clipboard --input'
        set -g @yank_selection 'clipboard'
        set -as terminal-features ',*:clipboard'

        bind -Troot C-w switch-client -T VimWindowMovements
        bind -TVimWindowMovements h select-pane -L
        bind -TVimWindowMovements j select-pane -D
        bind -TVimWindowMovements k select-pane -U
        bind -TVimWindowMovements l select-pane -R

        # status left look and feel
        set -g status-left-length 100
        set -g status-left ""
        set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=#{@thm_bg},fg=#{@thm_green}]  #S }}"
        set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
        set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_maroon}]  #{pane_current_command} "
        set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
        set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
        set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_yellow}]#{?window_zoomed_flag,  zoom ,}"

        # status right look and feel
        set -g status-right-length 100
        set -g status-right ""
        set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
        set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_blue}] 󰭦 %Y-%m-%d 󰅐 %H:%M "

        # Configure Tmux
        set -g status-style "bg=#{@thm_bg}"
        set -g status-justify "absolute-centre"

        # pane border look and feel
        setw -g pane-border-format ""
        setw -g pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_overlay_0}"
        setw -g pane-border-style "bg=#{@thm_bg},fg=#{@thm_surface_0}"

        # window look and feel
        set -wg automatic-rename on
        set -g automatic-rename-format "Window"

        # Window status formatting
        set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
        set -g window-status-style "bg=#282828,fg=#a89984"
        set -g window-status-last-style "bg=#282828,fg=#fabd2f"
        set -g window-status-activity-style "bg=#282828,fg=#8b8bb2"
        set -gF window-status-separator "#[bg=#282828,fg=#a89984]│"  # Dark gray separator for subtle contrast

        # Current window formatting (highlighted window)
        set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
        set -g window-status-current-style "bg=#98971a,fg=#282828,bold"
      '';
    };
  };
}
