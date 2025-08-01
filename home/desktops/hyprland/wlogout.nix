{pkgs, ...}: {
  programs.wlogout = {
    enable = true;
    style = ''
      * {
       all: unset;
       transition: 400ms cubic-bezier(0.05, 0.7, 0.1, 1);
      }
      window {
        background: rgba(0, 0, 0, 0.5);
      }
      button {
        font-size: 1rem;
        background-color: rgba(11, 11, 11, 0.4);
        color: #FFFFFF;
        margin: 2rem;
        border-radius: 2rem;
        padding: 3rem;
        background-repeat: no-repeat;
        background-position: center;
      }
      button:focus,
      button:active,
      button:hover {
        background-color: rgba(51, 51, 51, 0.5);
        border-radius: 2rem;
        outline-style: none;
      }
      #lock {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/lock.svg"));
      }

      #logout {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/logout.svg"));
      }

      #shutdown {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/shutdown.svg"));
      }

      #reboot {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/reboot.svg"));
      }

      #suspend {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/suspend.svg"));
      }

      #hibernate {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/hibernate.svg"));
      }
    '';
  };
}
