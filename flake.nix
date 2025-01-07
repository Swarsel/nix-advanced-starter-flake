{
  description = "Advanced NixOS starter config using disko, home-manager, and sops-nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs =
    { self, nixpkgs, systems, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs (import systems);
      # forAllSystems = nixpkgs.lib.genAttrs [
      #   "x86_64-linux"
      #   "aarch64-linux"
      #   "x86_64-darwin"
      #   "aarch64-darwin"
      # ];
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      apps = forAllSystems
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            bootstrap = pkgs.writeShellApplication
              {
                name = "bootstrap";
                runtimeInputs = [ pkgs.git ];
                text = builtins.readFile ./scripts/bootstrap.sh;
              };
          in
          {
            default = {
              type = "app";
              program = "${bootstrap}/bin/bootstrap";
            };
          });

      templates.default = {
        description = "Starter flake using disko, home-manager, and sops-nix";
        path = ./default;
      };
    };
}
