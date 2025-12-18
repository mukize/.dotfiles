{
  pkgs,
  pkgs-stable,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./kanata.nix
    ./nvidia.nix
  ];

  system.stateVersion = "25.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # Virtualisation #
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["mukize"];
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    containers.enable = true;
    docker = {
      enable = true;
      rootless.enable = true;
      rootless.setSocketVariable = true;
    };
    virtualbox = {
      host.enable = false;
      host.package = pkgs-stable.virtualbox;
      host.enableExtensionPack = true;
    };
  };
  users.extraGroups.vboxusers.members = ["mukize"];
  # -------------- #

  programs.adb.enable = true;
  boot = {
    plymouth.enable = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  hardware.opentabletdriver.enable = true;

  time.timeZone = "Africa/Johannesburg";
  i18n.defaultLocale = "en_ZA.UTF-8";
  users.users.mukize = {
    isNormalUser = true;
    description = "Mukize";
    extraGroups = [
      "audio"
      "adbusers"
      "libvirtd"
      "input"
      "networkmanager"
      "podman"
      "reboot"
      "shutdown"
      "suspend"
      "uinput"
      "wheel"
    ];
  };
  services = {
    udisks2.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "za";
      xkb.variant = "";
    };
    mysql = {
      enable = true;
      package = pkgs.mysql80;
    };
    gvfs.enable = true; # for removable media
    fwupd.enable = true; # firmware updates
  };
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      networkmanagerapplet
      brightnessctl
      gparted
    ];
  };

  # Networking #
  networking = {
    hostName = "mukize";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPortRanges = [
        {
          from = 54321;
          to = 54324;
        }
        {
          from = 8080;
          to = 8082;
        }
      ];
      allowedTCPPorts = [9099 5001];
      allowedUDPPorts = [9099 5001];
      allowedUDPPortRanges = [
        {
          from = 54321;
          to = 54324;
        }
        {
          from = 8080;
          to = 8082;
        }
      ];
    };
    nat = {
      enable = true;
      externalInterface = "enp0s20f0u4";
      internalInterfaces = ["lo"];
    };
  };
  services.mullvad-vpn.enable = true;
  services.miniupnpd = {
    enable = true;
    externalInterface = "enp0s20f0u4";
    internalIPs = ["lo"];
  };
  # ---------- #

  # zsh #
  programs.zsh.enable = true;
  users.users.mukize.shell = pkgs.zsh;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/mukize/.dotfiles";
  };
  # --- #

  # Power Management #
  powerManagement.enable = true;
  programs.auto-cpufreq.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
  services.thermald.enable = true;
  # ---------------- #

  # Bluetooth #
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # --------- #

  # Audio #
  security.rtkit.enable = true;
  services.playerctld.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # extraConfig.pipewire."92-low-latency" = {
    #   "context.properties" = {
    #     "default.clock.rate" = 44100;
    #     "default.clock.quantum" = 256;
    #   };
    # };
  };

  musnix.enable = true;
  musnix.rtcqs.enable = true;
  # musnix.kernel.realtime = true; # TODO: nvidia drivers don't support realtime
  # musnix.kernel.packages = pkgs.linuxPackages_latest_rt;
  # musnix.soundcardPciId = "00:1f.3";
  # ----- #

  # Graphics #
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [intel-vaapi-driver intel-media-driver vpl-gpu-rt];
  services.displayManager = {
    enable = true;
    gdm.enable = true;
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  xdg.portal.enable = true;
  security.pam.services.hyprlock = {};
  # -------- #

  # Stylix #
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    image = ./wallpaper.png;
    polarity = "dark";
    cursor = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePineDawn-Linux";
      size = 24;
    };
    fonts.monospace.package = pkgs.nerd-fonts.zed-mono;
    fonts.monospace.name = "ZedMonoNerdFont";
    fonts.sizes = {
      desktop = 10;
      applications = 10;
      terminal = 13;
    };
    opacity.terminal = 0.75;
  };
  # ------ #

  # Gaming #
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  programs.gamemode = {
    enable = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  # ------ #
}
