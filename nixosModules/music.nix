{ pkgs, musnix, ... }:
{
  imports = [ musnix.nixosModules.musnix ];
  musnix.enable = true;
  musnix.rtcqs.enable = true;
  users.users.mukize.extraGroups = [ "audio" ];
  # musnix.soundcardPciId = "00:1f.3";

  # home.sessionVariables =
  #   let
  #     makePluginPath =
  #       format:
  #       (lib.makeSearchPath format [
  #         "$HOME/.nix-profile/lib"
  #         "/run/current-system/sw/lib"
  #         "/etc/profiles/per-user/$USER/lib"
  #       ])
  #       + ":$HOME/.${format}";
  #   in
  #   {
  #     DSSI_PATH = makePluginPath "dssi";
  #     LADSPA_PATH = makePluginPath "ladspa";
  #     LV2_PATH = makePluginPath "lv2";
  #     LXVST_PATH = makePluginPath "lxvst";
  #     VST_PATH = makePluginPath "vst";
  #     VST3_PATH = makePluginPath "vst3";
  #   };
  environment.systemPackages = with pkgs; [
    decent-sampler
    demucs-rs
    reaper
    bitwig-studio6
  ];
}
