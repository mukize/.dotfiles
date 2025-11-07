{ pkgs, zen-browser, ... }: rec {

  imports = [ zen-browser.homeModules.twilight ];
  home.stateVersion = "25.05";
  home.username = "mukize";
  home.homeDirectory = "/home/mukize";
  home.sessionVariables = {
    EDITOR = "nvim";
    # MOZ_LEGACY_PROFILES = "1";
    PNPM_HOME = home.homeDirectory + "/.pnpm";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    HYPRSHOT_DIR = "~/Pictures/Screenshots";
    AQ_DRM_DEVICES = "/dev/dri/card2";
    PATH = "$PATH:/home/mukize/.local/share/yabridge:/home/mukize/.pnpm";
  };
  home.shellAliases = {
    "cd" = "z";
    "nv" = "nvim";
    "p" = "pnpm";
    "px" = "pnpx";
  };
  home.packages = with pkgs; [
    ### Applications
    decent-sampler guitarix gxplugins-lv2 calf # music
    gparted
    kdePackages.kdenlive
    gimp
    hyprshot hyprpicker hyprsysteminfo
    onlyoffice-desktopeditors
    nautilus gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
      sushi gdk-pixbuf ffmpegthumbnailer kdePackages.kdegraphics-thumbnailers kdePackages.kdesdk-thumbnailers
    mpv
    vlc
    giada
    protontricks
    docker-compose
    obsidian
    opentabletdriver
    pavucontrol
    reaper
    spotify
    styluslabs-write
    discord
    qjackctl
    xournalpp
    # wineWowPackages.yabridge
    wine-wayland
    winetricks
    # yabridge
    # yabridgectl
    bottles
    wineasio
    haruna
    ### CLI
    neovim
    devenv
    exercism
    imagemagick
    bc
    android-file-transfer
    dysk
    gemini-cli
    ffmpeg
    gnumake
    jq
    presenterm
    grim slurp # screenshots
    just mprocs
    manix nix-init # nix utils
    unzip unrar ouch # archive utils
    sqlite
    wget
    vagrant
    ### Libaries
    inotify-tools
    wl-clipboard
    libinput
    libinput-gestures
    ### fonts
    noto-fonts-color-emoji
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    ### Languages
    gcc
    cargo
    nodejs_24 yarn pnpm
    python3 uv
    ocaml ocamlPackages.utop
    ghc haskell-language-server stack
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-twilight.desktop";
      "x-scheme-handler/http" = "zen-twilight.desktop";
      "x-scheme-handler/https" = "zen-twilight.desktop";
      "x-scheme-handler/about" = "zen-twilight.desktop";
      "x-scheme-handler/unknown" = "zen-twilight.desktop";
    };
  };

  # Stylix #
  stylix.targets.waybar.enable = false;
  stylix.targets.zen-browser.enable = false;
  stylix.targets.gtk.extraCss = ''
    @define-color window_fg_color #f0f2fc;
  '';
  # ------ #

  # Services #
  services = {
    hyprpaper.enable = true;
    playerctld.enable = true;
    dunst = {
      enable = true;
      settings = {
        global.origin = "top-center";
        global.offset = "(0, 20)";
        global.alignment = "center";
        global.corner_radius = 8;
        urgency_low.timeout = 5;
        urgency_normal.timeout = 5;
      };
    };
    # fusuma = {
    #   enable = true;
    #   settings = let bash = "/etc/profiles/per-user/mukize/bin/bash"; in {
    #     swipe."3".up.command = bash + " ~/.dotfiles/scripts/dunst_osd.sh volume-up";
    #     swipe."3".down.command = bash + " ~/.dotfiles/scripts/dunst_osd.sh volume-down";
    #     hold."3".command = "/etc/profiles/per-user/mukize/bin/playerctl play-pause";
    #   };
    # };
    udiskie = {
      enable = true;
      settings.program_options = {
        file_manager = "nautilus";
        device_config = [
          {
            id_uuid = [ "80C5-B031" ];
            options = [ "exec" ];
          }
        ];
      };
    };
    # swayosd = {
    #   enable = true;
    #   stylePath = ./swayosd/style.css;
    # };
  };
  #----------#

  # Programs #
  programs = {
    java.enable = true;
    bash.enable = true;
    bat.enable = true;
    fd.enable = true;
    gpg.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
    obs-studio.enable = true;
    tofi = {
      enable = true;
      settings = {
        width = "25%";
        height = "50%";
      };
    };
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
      defaultOptions = [ "--info=inline-right" "--ansi" "--border=none" ];
    };
    ghostty = {
      enable = true;
      settings = {
        gtk-tabs-location = "bottom";
        adw-toolbar-style = "flat";
        gtk-wide-tabs = true;
        gtk-custom-css = [
          "~/.dotfiles/ghostty/style.css"
        ]; # TODO: Need to do this in a better way
        keybind = [
          "alt+h=previous_tab"
          "alt+l=next_tab"
          "shift+alt+h=move_tab:-1"
          "shift+alt+l=move_tab:1"
          "global:ctrl+`=toggle_quick_terminal"
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
    lutris = {
      enable = true;
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
    oh-my-posh = {
      enable = true;
      useTheme = "pure";
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
        plugins = [ "aliases" "gitfast" "ssh" ];
      };
    };
    zen-browser = {
      enable = true;
      profiles.default = {
        id = 0;
        search = {
          force = true;
          default = "ddg";
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
