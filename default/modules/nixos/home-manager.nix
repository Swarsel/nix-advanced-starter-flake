{ self, inputs, ... }:
{
  home-manager.users.test.imports = [
    inputs.sops-nix.homeManagerModules.sops
    "${self}/modules/home"
  ];
}
