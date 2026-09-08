{ pkgs, ... }:
{
  networking = {
    hostName = "mukize";
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
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
      allowedTCPPorts = [
        9099
        5001
        57621
        3773 # t3code
      ];
      allowedUDPPorts = [
        9099
        5001
        5353
      ];
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
      internalInterfaces = [ "lo" ];
    };
  };

  programs.openvpn3.enable = true;
  services.mullvad-vpn.enable = true;
  services.miniupnpd = {
    enable = false;
    externalInterface = "enp0s20f0u4";
    internalIPs = [ "lo" ];
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

}
