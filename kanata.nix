{ ... }:

{
  boot.kernelModules = [ "uinput" ];
  hardware.uinput.enable = true;
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  users.groups.uinput = { };
  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [ "input" "uinput" ];
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          #`ls /dev/input/by-path/`
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          "/dev/input/by-id/usb-Compx_2.4G_Wireless_Receiver-event-kbd"
        ];
        extraDefCfg = ''
          process-unmapped-keys yes
          concurrent-tap-hold yes
          rapid-event-delay 5
        '';
        config = ''
                    (defsrc
                     caps
                    )
                    (defalias
          	    escctrl (tap-hold-press 0 175 esc lctrl)
                    )
                    (deflayer base
                     @escctrl
                    )
        '';
      };
    };
  };
}

