{
  description = "Build NixOS images for various ARM single computer boards";
  # pin this to unstable
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }: {
    packages.aarch64-linux = import ./. {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
    };
  };
}
