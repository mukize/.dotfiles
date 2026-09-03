{
  pkgs,
  lib,
  config,
  ...
}@inputs:
{
  imports = [
  ];
  fonts.fontconfig.enable = true;
  home = {
    pointerCursor.enable = true;
    stateVersion = "26.05";
    username = "mukize";
    homeDirectory = "/home/mukize";
    sessionVariables = {
      PNPM_HOME = config.home.homeDirectory + "/.pnpm";
      XDG_SESSION_TYPE = "wayland";
      PATH = lib.join ":" [
        "$PATH"
        "/home/mukize/.local/share/yabridge"
        "${config.home.sessionVariables.PNPM_HOME}/bin"
      ];
    };
    shellAliases = {
      "cd" = "z";
    };
    packages = with pkgs; ([
      # Video & Audio
      qjackctl
      spotify
      pavucontrol
      pulseaudioFull
      ffmpeg
      haruna
      gimp
      # Chat
      slack
      discord
      # Tools
      gnumake
      imagemagick
      jq
      just
      manix
      nix-init
      ouch
      unzip
      sqlite
      wget
      hyprpicker
      vagrant
      wl-clipboard
      # misc
      obsidian
      opentabletdriver
      nerd-fonts.jetbrains-mono
      onlyoffice-desktopeditors
      android-file-transfer
    ]);
  };

  # xdg.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-twilight.desktop";
      "x-scheme-handler/http" = "zen-twilight.desktop";
      "x-scheme-handler/https" = "zen-twilight.desktop";
      "x-scheme-handler/about" = "zen-twilight.desktop";
      "x-scheme-handler/unknown" = "zen-twilight.desktop";
      "application/pdf" = "sioyek.desktop";
      "application/x-pdf" = "sioyek.desktop";
      "application/x-cbr" = "sioyek.desktop";
      "application/x-cbz" = "sioyek.desktop";
    };
  };

  stylix.targets = {
    opencode.enable = false;
    sioyek.enable = true;
    zen-browser.enable = false;
    vicinae.opacity.enable = false;
    ghostty.colors.enable = false;
  };
  wayland.windowManager.hyprland.systemd.enable = false;

  services = {
    playerctld.enable = true;
    voxtype = {
      enable = false;
      package = pkgs.voxtype-vulkan;
      loadModels = [
        "tiny.en"
        "base.en"
      ];
      environment.VOXTYPE_VULKAN_DEVICE = "nvidia";

    };
    udiskie = {
      enable = true;
      settings.program_options = {
        file_manager = "nautilus";
        device_config = [
          {
            id_type = "ext4";
            options = [
              "nosuid"
              "nodev"
              "noatime"
              "errors=remount-ro"
            ];
          }
        ];
      };
    };
  };

  programs = {
    gh.enable = true;
    yt-dlp.enable = true;
    zathura.enable = true;
    sioyek = {
      enable = true;
      config.startup_commands = lib.mkForce [ ]; # stylix keeps changing to dark mode
    };
    bash.enable = true;
    bat.enable = true;
    fd.enable = true;
    gpg.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    obs-studio.enable = true;
    btop = {
      enable = true;
      extraConfig = ''
        vim_keys = True
        proc_tree = True
        proc_aggregate = True
        proc_filter_kernel = True
      '';
    };
    eza = {
      enable = true;
      extraOptions = [ "--group-directories-first" ];
    };
    fzf = {
      enable = true;
      defaultOptions = [
        "--info=inline-right"
        "--ansi"
        "--border=none"
      ];
    };
    ghostty = {
      enable = true;
      settings = {
        gtk-tabs-location = "bottom";
        adw-toolbar-style = "flat";
        background-blur = true;
        shell-integration-features = "ssh-env,ssh-terminfo";
        theme = "noctalia";
        gtk-wide-tabs = true;
        gtk-custom-css = [
          "~/.dotfiles/.config/ghostty/tab-styling.css"
        ];
        keybind = [
          "performable:ctrl+c=copy_to_clipboard"
          "shift+alt+h=move_tab:-1"
          "shift+alt+l=move_tab:1"
          "performable:alt+h=goto_split:down"
          "performable:alt+k=goto_split:up"
          "performable:alt+j=goto_split:right"
          "performable:alt+l=goto_split:left"
          "alt+l=next_tab"
          "alt+h=previous_tab"
          "ctrl+alt+l=next_tab"
          "ctrl+alt+h=previous_tab"
        ];
      };
    };
    git = {
      enable = true;
      settings = {
        user.name = "Mukize";
        user.email = "patrickmukize@gmail.com";
        init.defaultBranch = "main";
      };
    };
    hyprlock = {
      enable = true;
      extraConfig = ''
        general {
            ignore_empty_input = true
            hide_cursor = true
        }
        background {
            monitor =
            path = screenshot
            blur_passes = 2
        }
      '';
    };
    java = {
      enable = true;
      package = pkgs.jdk25;
    };
    tmux = {
      enable = true;
      extraConfig = ''
        set -g @catppuccin_flavor 'macchiato'
        run ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

        set -g status-left ""
        set -g status-right '#[fg=#{@thm_crust},bg=#{@thm_teal}] session: #S '
        set -g status-right-length 100
        set -g status-style padding=0
      '';
    };
    vicinae = {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
      };
      settings = {
        keybinding = "emacs";
        close_on_focus_loss = true;
        launcher_window.opacity = 0.75;
        providers = {
          files = {
            enabled = true;
          };
          clipboard = {
            enabled = false;
            preferences = {
              eraseOnStartup = true;
              monitoring = false;
            };
          };
        };
      };
      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        nix
        mullvad
      ];
    };
    oh-my-posh = {
      enable = true;
      useTheme = "pure";
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      initContent = ''
        bindkey '^ ' autosuggest-accept
        bindkey '^P' history-beginning-search-backward
        bindkey '^N' history-beginning-search-forward
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [
          "aliases"
          "gitfast"
          "ssh"
          "colored-man-pages"
          "emoji"
          "git-auto-fetch"
          "cabal"
        ];
      };
    };
    zen-browser = {
      enable = true;
      profiles.default = {
        id = 0;
        keyboardShortcuts = [
          {
            id = "zen-workspace-switch-1";
            key = "1";
            modifiers.control = true;
          }
          {
            id = "zen-workspace-switch-2";
            key = "2";
            modifiers.control = true;
          }
          {
            id = "zen-workspace-switch-3";
            key = "3";
            modifiers.control = true;
          }
          {
            id = "zen-workspace-switch-4";
            key = "4";
            modifiers.control = true;
          }
          {
            id = "zen-workspace-switch-5";
            key = "5";
            modifiers.control = true;
          }
        ];
        search = {
          force = true;
          default = "ddg";
          engines = {
            mynixos = {
              name = "My NixOS";
              urls = [
                {
                  template = "https://mynixos.com/search?q={searchTerms}";
                  params = [
                    {
                      name = "query";
                      value = "searchTerms";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nx" ]; # Keep in mind that aliases defined here only work if they start with "@"
            };
          };
        };
      };
      policies.Preferences = {
        "zen.ctrlTab.show-pending-tabs"."Value" = true;
        "zen.tabs.show-newtab-vertical"."Value" = false;
        "zen.theme.acrylic-elements"."Value" = true;
        "zen.welcome-screen.seen"."Value" = true;
        "zen.view.use-single-toolbar"."Value" = true;
      };
    };
  };
}
