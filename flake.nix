{
  description = "My Nix/NixOS Ecosystem";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    import-tree.url = "github:vic/import-tree";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions.url = "github:vicinaehq/extensions";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    llm-agents.url = "github:numtide/llm-agents.nix";

    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    noctalia-greeter.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: {
    packages = builtins.mapAttrs (system: pkgs: {
      tone3000-plugin = pkgs.callPackage ./packages/tone3000-plugin { };
    }) inputs.nixpkgs.legacyPackages;

    nixosConfigurations.mukize = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = inputs;
      system = "x86_64-linux";
      modules = [
        (inputs.import-tree ./nixosModules)
        inputs.noctalia-greeter.nixosModules.default
        inputs.noctalia.nixosModules.default
        inputs.stylix.nixosModules.stylix
        inputs.musnix.nixosModules.musnix
        inputs.nix-index-database.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            inputs.neovim-nightly-overlay.overlays.default
          ];
          home-manager = {
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            useUserPackages = true;
            enableLegacyProfileManagement = true;
            extraSpecialArgs = inputs;
            users.mukize.imports = [
              (inputs.import-tree ./homeModules)
              inputs.zen-browser.homeModules.twilight
              inputs.vicinae.homeManagerModules.default
            ];
          };
          nix.settings.extra-substituters = [
            "https://cache.numtide.com"
            "https://cache.nixos-cuda.org"
            "https://vicinae.cachix.org"
            "https://noctalia.cachix.org"
            "https://nix-community.cachix.org"
          ];
          nix.settings.extra-trusted-public-keys = [
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
            "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        }
      ];
    };
  };
}
