{
  self,
  lib,
  systems,
  inputs,
  outputs,
  ...
}:
{

  forAllSystems = lib.genAttrs (import systems);

  mkHost = host: {
    ${host} = lib.nixosSystem {
      specialArgs = {
        inherit
          self
          lib
          inputs
          outputs
          ;
      };
      modules = [
        inputs.disko.nixosModules.disko
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager
        "${self}/hosts/${host}"
        "${self}/hosts/${host}/hardware-configuration.nix"
        "${self}/modules/nixos"
      ];
    };
  };

  mkHosts =
    hosts: lib.foldl (acc: set: acc // set) { } (lib.map (host: lib.custom.mkHost host) hosts);

  readHosts = lib.attrNames (builtins.readDir "${self}/hosts/");
}
