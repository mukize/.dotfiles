{ pkgs, zen-browser, ... }: {

  imports = [ zen-browser.homeModules.twilight ./stylix.nix ];
  home.stateVersion = "25.05";
  home.username = "mukize";
  home.homeDirectory = "/home/mukize";
  home.sessionVariables = {
    EDITOR = "nvim";
    MOZ_LEGACY_PROFILES = "1";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    HYPRSHOT_DIR = "~/Pictures/Screenshots";
    AQ_DRM_DEVICES = "/dev/dri/card2";
  };
  home.shellAliases = {
    "cd" = "z";
    "nv" = "nvim";
  };
  home.packages = with pkgs; [
    ### Applications
    firefox
    hyprshot
    hyprpicker
    hyprsysteminfo
    nautilus
    neovim
    mission-center
    mullvad-vpn
    obsidian
    pavucontrol
    spotify
    webcord
    wpsoffice
    ### CLI
    bc
    dysk
    ffmpeg
    gnumake
    jq
    grim
    slurp
    just
    mprocs
    unzip
    sqlite
    wget
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
    nodejs_24
    python3Full
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

  services = {
    hyprpaper.enable = true;
    playerctld.enable = true;
    dunst = {
      enable = true;
      settings = {
        global.corner_radius = 8;
        urgency_low.timeout = 5;
        urgency_normal.timeout = 5;
      };
    };
    fusuma = {
      enable = true;
      settings = {
        swipe."3".up.command = "swayosd-client --output-volume raise";
        swipe."3".down.command = "swayosd-client --output-volume lower";
        hold."3".command = "playerctl play-pause";
      };
    };
    udiskie = {
      enable = true;
      settings.program_options.file_manager = "nautilus";
    };
    swayosd = {
      enable = true;
      stylePath = ./swayosd/style.css;
    };
  };
  programs = {
    bash.enable = true;
    bat.enable = true;
    fd.enable = true;
    gpg.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;
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
        gtk-custom-css = [
          "~/.dotfiles/ghostty/style.css"
        ]; # TODO: Need to do this in a better way
        keybind = [
          "alt+h=previous_tab"
          "alt+l=next_tab"
          "shift+alt+h=move_tab:-1"
          "shift+alt+l=move_tab:1"
        ];
      };
    };
    git = {
      enable = true;
      userName = "Mukize";
      userEmail = "patrickmukize@gmail.com";
      extraConfig.init.defaultBranch = "main";
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
    nh = {
      enable = true;
      flake = "~/.dotfiles";
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

}
