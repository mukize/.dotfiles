{
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    systemd.enable = true;
  };
  programs.noctalia-greeter = {
    enable = true;
    settings.hide_logo = true;
  };
}
