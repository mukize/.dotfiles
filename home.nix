{ pkgs, zen-browser, ... }: {

  imports = [ zen-browser.homeModules.twilight ./stylix.nix ];
  home.stateVersion = "25.05";
  home.username = "mukize";
  home.homeDirectory = "/home/mukize";
  home.sessionVariables = {
    EDITOR = "nvim";
    MOZ_LEGACY_PROFILES = "1";
    NIXOS_OZONE_WL = "1";
    HYPRSHOT_DIR = "~/Pictures/Screenshots";
  };
  home.shellAliases = {
    "cd" = "z";
    "nv" = "nvim";
  };
  home.packages = with pkgs; [
    # Applications #
    firefox
    hyprshot
    hyprpicker
    hyprsysteminfo
    libreoffice-fresh
    obsidian
    nautilus
    neovim
    mullvad-vpn
    spotify
    webcord
    # networkmanager_dmenu python313Packages.pygobject3
    # CLI #
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
    ### Libaries ###
    inotify-tools
    wl-clipboard
    ### fonts ###
    noto-fonts-color-emoji
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    ### Languages ###
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
    dunst.enable = true;
    hyprpaper.enable = true;
    playerctld.enable = true;
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
    ghostty.enable = true;
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
