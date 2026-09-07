{ pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
    image = ../wallpaper.png;
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
    opacity.terminal = 0.65;
  };
}
