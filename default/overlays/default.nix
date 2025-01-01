{
  self,
  inputs,
  lib,
  ...
}:
let
  additions =
    final: _:
    import "${self}/pkgs" {
      pkgs = final;
      inherit lib;
    };

  modifications = _: prev: {
  };

  nixpkgs-stable = final: _: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

in
{
  default =
    final: prev: (additions final prev) // (modifications final prev) // (nixpkgs-stable final prev);
}
