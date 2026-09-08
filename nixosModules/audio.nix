{ pkgs, musnix, ... }:
{
  imports = [ musnix.nixosModules.musnix ];

  security.rtkit.enable = true;
  services.playerctld.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
    extraConfig.jack."92-low-latency" = {
      "jack.properties" = {
        "node.latency" = "256/48000";
      };
    };
  };

  musnix.enable = true;
  musnix.rtcqs.enable = true;
  users.users.mukize.extraGroups = [ "audio" ];

  environment.systemPackages = with pkgs; [
    demucs-rs
    # reaper
    bitwig-studio6
    #
    decent-sampler
    neural-amp-modeler-lv2
    gmetronome
  ];
}
