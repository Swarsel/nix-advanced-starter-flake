{
  description = "<NAME>'s NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      systems,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      inherit (self) outputs;
      lib = (nixpkgs.lib // home-manager.lib).extend (
        _: _: {
          custom = import ./lib {
            inherit
              self
              lib
              inputs
              outputs
              systems
              ;
          };
        }
      );

    in
    {
      formatter = lib.custom.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit self lib inputs; };

      nixosConfigurations = lib.custom.mkHosts (lib.attrNames (builtins.readDir "${self}/hosts"));

    };
}
