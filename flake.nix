{
  description = "Build NixOS images for various ARM single computer boards";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs }: {
    packages.aarch64-linux = import ./. {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
    };
  };
}
