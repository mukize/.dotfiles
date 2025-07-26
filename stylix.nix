{ pkgs, ... }: {
  stylix.targets.waybar.enable = false;
  stylix.targets.zen-browser.enable = false;
  stylix.targets.gtk.extraCss = ''
    @define-color window_fg_color #f0f2fc;
  '';
}
