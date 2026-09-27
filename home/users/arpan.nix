{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
    gnumake
    unzip
  ];

  frost.home = {
    environment.cursor.enable = true;

    apps = {
      ai = {
        antigravity.enable = true;
        claude_code.enable = true;
        codex.enable = true;
        herdr.enable = true;
      };

      development = {
        cursor.enable = true;
        direnv.enable = true;
        emacs.enable = true;
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

      office = {
        obsidian.enable = true;
      };

      networking = {
        chrome.enable = true;
        qbittorrent.enable = true;
      };

      shell = {
        atuin.enable = true;
        bat.enable = true;
        curl.enable = true;
        eza.enable = true;
        fastfetch.enable = true;
        fzf.enable = true;
        jq.enable = true;
        kitty.enable = true;
        starship.enable = true;
        tmux.enable = true;
        tree.enable = true;
        wget.enable = true;
        yazi.enable = true;
        zsh.enable = true;
        zoxide.enable = true;
      };

      system = {
        ripgrep.enable = true;
        zip.enable = true;
      };

      utils = {
        vlc.enable = true;
      };

      virtualization = {
        docker.enable = true;
      };
    };

    ui = {
      tools.dms_theming.enable = true;
      wms.niri.enable = true;
    };
  };
}
