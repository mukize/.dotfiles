{
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "mukize" ];
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    containers.enable = true;
    docker = {
      enable = true;
      rootless.enable = true;
      rootless.setSocketVariable = true;
    };
  };
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "mukize" ];
}
