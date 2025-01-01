{
  description = "Advanced NixOS starter config using disko, home-manager, and sops-nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs =
    { nixpkgs, systems, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs (import systems);
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      templates.default = {
        description = "Starter flake using disko, home-manager, and sops-nix";
        path = ./default;
      };
    };
}
