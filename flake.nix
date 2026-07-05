{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    auto-cpufreq.url = "github:AdnanHodzic/auto-cpufreq";
    auto-cpufreq.inputs.nixpkgs.follows = "nixpkgs";

    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    llm-agents.url = "github:numtide/llm-agents.nix";
  };
  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      llm-agents-pkgs = inputs.llm-agents.packages.${system};
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    in
    {
      nixosConfigurations.mukize = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          ./configuration.nix
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
          inputs.auto-cpufreq.nixosModules.default
          inputs.musnix.nixosModules.musnix
          # inputs.vicinae.nixosModules.default
          {
            nixpkgs.overlays = overlays;
            home-manager.useGlobalPkgs = true;
            home-manager.backupFileExtension = "backup";
            home-manager.useUserPackages = true;
            home-manager.enableLegacyProfileManagement = true;
            home-manager.extraSpecialArgs = {
              inherit (inputs) zen-browser vicinae-extensions vicinae;
              inherit pkgs-stable;
              inherit llm-agents-pkgs;
            };
            home-manager.users.mukize = import ./home.nix;
          }
        ];
      };
    };
}
