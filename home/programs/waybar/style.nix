{ ... }:
{
  programs.waybar.style = ''
    @define-color background #1A1A1A;
    @define-color foreground #DCD7BA;
    @define-color foreground-dark #C8C093;
    @define-color power #DCA561;
    @define-color red #C34043;
    @define-color orange #FF9E3B;
    @define-color overlay #2A2A37;

    * {
    font-family: "CaskaydiaMono Nerd Font Mono";
    font-size: 14px;
    opacity: 1;
    margin: 0px;
    padding: 0px;
    }
    window#waybar {
    background-color: transparent;
    border-radius: 0;
    transition-property: background-color;
    transition-duration: 0.5s;
    }

    window#waybar > box {
    padding: 5px 0;
    }

    button {
    box-shadow: inset 0 -3px transparent;
    border: none;
    border-radius: 10px;
    }

    button:hover {
    background: inherit;
    border: none;
    }

    /* Workspaces styles */

    #workspaces {
    font-weight: 800;
    margin-right: 5px;
    background-color: @background;
    color: @foreground;
    border-radius: 10px;
    }

    #workspaces button {
    border-radius: 10px;
    padding: 0 8px;
    color: inherit;
    background-color: transparent;
    transition: 0.5s ease-out;
    }

    #workspaces button:hover {
    background: rgba(0, 0, 0, 0.2);
    }

    #workspaces button.active {
    background-color: @foreground-dark;
    color: @background;
    }

    #workspaces button.active:nth-child(1) {
    border-radius: 10px 0 0 10px;
    }
    #workspaces button.active:nth-last-child(1) {
    border-radius: 0 10px 10px 0;
    }

    #workspaces button.urgent {
    border-bottom: 2px solid @orange;
    border-radius: 0;
    }

    #workspaces button.urgent:nth-child(1) {
    border-bottom: 2px solid @orange;
    border-radius: 10px 0 0 10px;
    }

    #workspaces button.urgent:nth-last-child(1) {
    border-bottom: 2px solid @orange;
    border-radius: 0 10px 10px 0;
    }

    /* Hardware group styles */

    #hardware {
    margin-right: 5px;
    }

    #cpu {
    padding-right: 10px;
    }

    #memory {
    padding-left: 10px;
    }

    /* Audio module styles */

    #sound {
    background-color: @background;
    color: @foreground;
    border-radius: 10px;
    margin-right: 5px;
    }

    #pulseaudio:hover {
    background-color: @overlay;
    }

    #pulseaudio {
    font-weight: 700;
    padding: 6px 10px;
    border-radius: 10px;
    }

    #pulseaudio.output.muted {
    color: @red;
    }
    #pulseaudio.input.source-muted {
    color: @red;
    }

    /* Privacy */

    #privacy {
    background-color: @background;
    color: @power;
    border: 1.5px solid @power;
    padding: 6px 10px;
    border-radius: 10px;
    margin-right: 10px;
    }

    /* Language */

    #language {
    margin-right: 5px;
    }

    /* Time group styles */

    #time {
    border-radius: 10px;
    font-weight: 700;
    background-color: @background;
    color: @foreground;
    }

    #clock.simple {
    padding: 6px 10px;
    background-color: @foreground-dark;
    color: @background;
    border-radius: 0 10px 10px 0;
    font-weight: 700;
    }

    #clock {
    padding: 6px 10px;
    border-radius: 10px 0 0 10px;
    }

    /* Tray */

    #tray {
    margin-right: 5px;
    }

    #tray > .passive {
    -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
    -gtk-icon-effect: highlight;
    }

    /* Network group styles */

    #network {
    font-weight: 700;
    background-color: @background;
    color: @foreground;
    padding: 6px 10px;
    border-radius: 10px;
    margin-right: 5px;
    }

    /* Power group styles */

    #battery {
    font-weight: 700;
    background-color: @background;
    color: @foreground;
    padding: 6px 10px;
    border-radius: 10px;
    }

    #custom-power {
    font-weight: 700;
    background-color: @background;
    color: @foreground;
    padding: 6px 10px;
    border-radius: 10px;
    margin-right: 5px;
    }

    /* Default module styles */

    #temperature,
    #hardware,
    #window,
    #tray,
    #language {
    font-weight: 700;
    background-color: @background;
    color: @foreground;
    padding: 6px 10px;
    border-radius: 10px;
    }

    .modules-right {
    padding: 0 10px;
    }

    .modules-left {
    padding: 0 10px;
    }

    label:focus {
    background-color: #000;
    }

  '';
}
