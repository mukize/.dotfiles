{ pkgs, ... }:
{
  system.stateVersion = "26.05";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    systemd.enable = true;
  };
  programs.noctalia-greeter = {
    enable = true;
    settings.hide_logo = true;
  };
  programs.nix-index-database = {
    enable = true;
    comma.enable = true;
  };
  services.gnome.gnome-keyring.enable = true;

  hardware.xpadneo.enable = true;
  hardware.xone.enable = true;
  services.udev.packages = [ pkgs.game-devices-udev-rules ];

  boot.plymouth.enable = true;
  hardware.opentabletdriver.enable = true;

  time.timeZone = "Africa/Johannesburg";
  i18n.defaultLocale = "en_ZA.UTF-8";
  users.users.mukize = {
    isNormalUser = true;
    description = "Mukize";
    extraGroups = [
      "adbusers"
      "gamemode"
      "gns3"
      "dialout"
      "input"
      "kvm"
      "libvirtd"
      "networkmanager"
      "podman"
      "reboot"
      "seat"
      "shutdown"
      "suspend"
      "ubridge"
      "uinput"
      "wheel"
      "wireshark"
    ];
  };
  services = {
    gnome.sushi.enable = true;
    udisks2.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "za";
      xkb.variant = "";
    };
    gvfs.enable = true; # for removable media
    fwupd.enable = true; # firmware updates
  };
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };
    systemPackages = with pkgs; [
      networkmanagerapplet
      brightnessctl
      openvpn
      adwaita-icon-theme
      rose-pine-icon-theme
      qogir-icon-theme
      dracula-icon-theme
      gparted
      gpauth
      gp-saml-gui
      gpclient
      xwayland-satellite
      vista-fonts
      inetutils
      nautilus
      bubblewrap
    ];
  };
  security.wrappers.ubridge = {
    source = "${pkgs.ubridge}/bin/ubridge";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    owner = "root";
    group = "wheel"; # or your GNS3 group
    permissions = "u+rx,g+rx";
  };

  ## zsh
  programs.zsh.enable = true;
  users.users.mukize.shell = pkgs.zsh;
  ## ---

  # Power Management #
  powerManagement.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
  services.thermald.enable = true;
  # ---------------- #

  # Bluetooth #
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
      Enable = "Source,Sink,Media,Socket";
    };
  };
  # --------- #

  # Graphics #
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-vaapi-driver
    intel-media-driver
    vpl-gpu-rt
  ];
  services.displayManager = {
    enable = true;
    defaultSession = "hyprland-uwsm";
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };
  security.pam.services.hyprlock = { };
  # -------- #

  fonts.packages = with pkgs; [
    lora
    literata
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-serif
    source-sans
    figtree
    ibm-plex
    maple-mono.NF
    inter
  ];

  ## Gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    extraPackages = with pkgs; [
      gamemode.lib
      gamemode
      gamescope
    ];
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };
  programs.gamemode = {
    enable = true;
    settings = {
      general.renice = 10;
      gpu.gpu_device = 0;
    };
  };
  programs.gamescope = {
    enable = true;
    capSysNice = false; # was breaking steam
  };
  ## ---

  ## Nix GC
  programs.nh = {
    enable = true;
    clean.enable = false;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/mukize/.dotfiles";
  };
  services.angrr = {
    enable = true;
    enableNixGcIntegration = true;
  };
  nix.gc.automatic = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Decent Sampler dirty fix
      expat
      alsa-lib
    ];
  };
  ## ---
}
