{
  pkgs,
  zen-browser,
  pkgs-stable,
  lib,
  ...
}@inputs:
rec {
  imports = [
    zen-browser.homeModules.twilight
    # inputs.vicinae.homeManagerModules.default
  ];
  fonts.fontconfig.enable = true;
  home = {
    stateVersion = "26.05";
    username = "mukize";
    homeDirectory = "/home/mukize";
    sessionVariables = {
      EDITOR = "nvim";
      # MOZ_LEGACY_PROFILES = "1";
      PNPM_HOME = home.homeDirectory + "/.pnpm";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      HYPRSHOT_DIR = "~/Pictures/Screenshots";
      PATH = "$PATH:/home/mukize/.local/share/yabridge:${home.homeDirectory}/.pnpm/bin";
      BAR = "foo";
    }
    // (
      let
        makePluginPath =
          format:
          (pkgs.lib.makeSearchPath format [
            "$HOME/.nix-profile/lib"
            "/run/current-system/sw/lib"
            "/etc/profiles/per-user/$USER/lib"
          ])
          + ":$HOME/.${format}";
      in
      {
        DSSI_PATH = makePluginPath "dssi";
        LADSPA_PATH = makePluginPath "ladspa";
        LV2_PATH = makePluginPath "lv2";
        LXVST_PATH = makePluginPath "lxvst";
        VST_PATH = makePluginPath "vst";
        VST3_PATH = makePluginPath "vst3";
      }
    );
    shellAliases = {
      "cd" = "z";
      "nv" = "nvim";
      "nb" = "nix build";
      "p" = "pnpm";
      "px" = "pnpx";
    };
    packages = with pkgs; ([
      ### Music
      decent-sampler
      # guitarix
      calf
      pkgs-stable.giada
      reaper
      bitwig-studio6
      drumgizmo
      x42-avldrums
      bankstown-lv2
      inputs.llm-agents-pkgs.pi
      inputs.llm-agents-pkgs.claude-code
      ### Applications
      gparted
      kdePackages.kdenlive
      ollama
      unzip
      openvpn
      gimp
      hyprshot
      hyprpicker
      hyprpaper
      mendeley
      numlockx
      hyprsysteminfo
      mpv
      haruna
      obsidian
      opentabletdriver
      pavucontrol
      spotify
      slack
      discord
      qjackctl
      xournalpp
      pulseaudioFull
      osu-lazer
      ### Files
      # TODO: check what I actually need for video thumbnails
      nautilus
      tree-sitter
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      sushi
      gdk-pixbuf
      ffmpegthumbnailer
      kdePackages.kdegraphics-thumbnailers
      kdePackages.kdesdk-thumbnailers
      onlyoffice-desktopeditors
      freeplane
      ### Wine
      protontricks
      # wineWowPackages.yabridge
      wine-wayland
      winetricks
      # yabridge
      # yabridgectl
      # bottles
      ### CLI
      neovim
      exercism
      imagemagick
      bc
      android-file-transfer
      dysk
      gemini-cli
      ffmpeg
      gnumake
      catimg
      jq
      grim
      slurp # screenshots
      just
      mprocs
      manix
      nix-init # nix utils
      ouch
      sqlite
      wget
      vagrant
      ### Libaries
      inotify-tools
      libnotify
      wl-clipboard
      libinput
      libinput-gestures
      musescore
      ### fonts
      noto-fonts-color-emoji
      font-awesome
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      ### Languages
      gcc
      cargo
      nodejs_24
      yarn
      pnpm
      python3
      uv
      ocaml
      ocamlPackages.utop
      lua-language-server
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
    waybar.enable = false;
    opencode.enable = false;
    zen-browser.enable = false;
    gtk.extraCss = ''
      @define-color window_fg_color #f0f2fc;
    '';
    vicinae.opacity.enable = false;
  };
  wayland.windowManager.hyprland.systemd.enable = false;

  services = {
    ollama.enable = false;
    hyprpaper = {
      enable = true;
      package = pkgs.hyprpaper;
    };
    playerctld.enable = true;
    mako = {
      enable = true;
      settings = {
        anchor = "top-center";
        border-radius = 8;
        default-timeout = 2000;
        # progress-color = "";
        # background-color = "#1e1e2e";
        # text-color = "#1e1e2e";
      };
    };
    dunst = {
      enable = false;
      settings = {
        global = {
          origin = "top-center";
          alignment = "center";
          corner_radius = 8;
        };
        urgency_low.timeout = 5;
        urgency_normal.timeout = 5;
      };
    };
    swaync = {
      enable = false;
      settings = {
        "ignore-gtk-theme" = true;
        positionX = "center";
      };
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
    swayosd = {
      enable = true;
    };
  };
  #----------#

  # Programs #
  programs = {
    opencode = {
      enable = true;
      tui.theme = "system";
      # tui.themes.custom = ./config/opencode.json;
    };
    sioyek = {
      enable = true;
      config = {
        startup_commands = lib.mkForce "";
        # ruler_mode = "1";
      };
    };
    mangohud.enable = true;
    wlogout.enable = true;
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
        gtk-wide-tabs = true;
        gtk-custom-css = [
          "~/.dotfiles/ghostty/style.css"
        ]; # TODO: Need to do this in a better way
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
    lutris = {
      enable = false;
    };
    nix-index = {
      enable = false;
      enableZshIntegration = true;
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
      # pop_to_root_on_close = true;
      systemd = {
        enable = false;
        autoStart = true;
      };
      settings = {
        imports = [ "config.json" ];
        keybinding = "emacs";
        close_on_focus_loss = true;
        launcher_window.opacity = 0.75;
        providers = {
          files = {
            enabled = true;
          };
          clipboard = {
            preferences = {
              eraseOnStartup = true;
              monitoring = false;
            };
          };
        };
      };
      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        # bluetooth
        nix
        mullvad
        pulseaudio
        wifi-commander
      ];
    };
    tofi = {
      enable = true;
      settings = {
        width = "25%";
        height = "50%";
      };
    };
    oh-my-posh = {
      enable = true;
      useTheme = "pure";
      # configFile = oh-my-posh/macchiato.omp.json;
      enableZshIntegration = true;
    };
    waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = builtins.fromJSON (builtins.readFile ./waybar/config.jsonc);
      };
      style = ./waybar/style.css;
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
  #----------#
}
