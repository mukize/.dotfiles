{pkgs, ...}: {
  services.pixiecore = {
    enable = true;
    openFirewall = true;
    mode = "quick";
    dhcpNoBind = true;
  };
}
