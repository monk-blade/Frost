{pkgs, ...}: {
  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    btop
    gnumake
    unzip
  ];

  frost.home = {
    apps = {
      ai = {
        claude_code.enable = true;
        codex.enable = true;
        herdr.enable = true;
      };

      development = {
        direnv.enable = true;
        git = {
          enable = true;
          userName = "Arpan";
          userEmail = "user@example.com";
          signByDefault = false;
        };
        nvim.enable = true;
      };

      langs = {
        go = {
          enable = true;
          toolchain.enable = true;
        };
        javascript = {
          enable = true;
          toolchain.enable = true;
        };
        nix.enable = true;
        python = {
          enable = true;
          toolchain.enable = true;
        };
        rust = {
          enable = true;
          toolchain.enable = true;
        };
      };

      networking = {
        chrome.enable = true;
        qbittorrent.enable = true;
      };

      shell = {
        bat.enable = true;
        curl.enable = true;
        eza.enable = true;
        fastfetch.enable = true;
        jq.enable = true;
        kitty.enable = true;
        starship.enable = true;
        tmux.enable = true;
        tree.enable = true;
        wget.enable = true;
        zsh.enable = true;
        zoxide.enable = true;
      };

      system = {
        zip.enable = true;
      };

      utils = {
        vlc.enable = true;
      };

      virtualization = {
        docker.enable = true;
      };
    };

    ui.wms.niri.enable = true;
  };
}
