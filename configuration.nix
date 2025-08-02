{ pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ./kanata.nix ./nvidia.nix ];

  system.stateVersion = "25.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot = {
    plymouth.enable = true;
    kernelModules = [ "uinput" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  time.timeZone = "Africa/Johannesburg";
  i18n.defaultLocale = "en_ZA.UTF-8";
  users.users.mukize = {
    isNormalUser = true;
    description = "Mukize";
    extraGroups = [
      "networkmanager"
      "wheel"
      "uinput"
      "input"
      "reboot"
      "shutdown"
      "suspend"
      "audio"
    ];
  };
  services = {
    xserver = {
      enable = true;
      xkb.layout = "za";
      xkb.variant = "";
    };
    udisks2.enable = true; # # auto mounting
    fwupd.enable = true; # firmware updates
  };
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [ networkmanagerapplet brightnessctl ];
  };

  # Networking #
  networking = {
    hostName = "mukize";
    networkmanager.enable = true;
  };
  services.mullvad-vpn.enable = true;
  # ---------- #

  # zsh #
  programs.zsh.enable = true;
  users.users.mukize.shell = pkgs.zsh;
  # --- #

  # Power Management #
  powerManagement.enable = true;
  programs.auto-cpufreq.enable = true;
  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "ignore";
  services.thermald.enable = true;
  # ---------------- #

  # Bluetooth #
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # --------- #

  # Audio #
  services.playerctld.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
  musnix.enable = true;
  # ----- #

  # graphics #
  hardware.graphics.enable = true;
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
  security.rtkit.enable = true;
  security.pam.services.hyprlock = { };
  # ------------------- #

  # Stylix #
  stylix = {
    enable = true;
    base16Scheme =
      "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    image = ./wallpaper.png;
    polarity = "dark";
    cursor = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePineDawn-Linux";
      size = 24;
    };
    fonts.monospace = {
      package = pkgs.nerd-fonts.zed-mono;
      name = "ZedMonoNerdFont";
    };
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
  programs.gamemode.enable = true;
  # ------ #

}
