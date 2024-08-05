{ pkgs ? import <nixpkgs> {} }:

let
  unfreePkgs = import pkgs.path {
    config.allowUnfree = true;
    inherit (pkgs) system;
  };
  aarch64Pkgs = unfreePkgs.pkgsCross.aarch64-multiplatform;

  buildImage = pkgs.callPackage ./pkgs/build-image {};
  aarch64Image = pkgs.callPackage ./pkgs/aarch64-image {};
  rockchip = uboot: pkgs.callPackage ./images/rockchip.nix {
    inherit uboot;
    inherit aarch64Image buildImage;
  };
in rec {
  inherit aarch64Image;

  ubootRadxaZero3 = aarch64Pkgs.buildUBoot {
    src = pkgs.fetchFromGitHub {
      owner = "Kwiboo";
      repo = "u-boot-rockchip";
      rev = "17274b90f5c9ff3d1bbe5bf434e83270f9c6d9d9";
      hash = "sha256-Axul1C2VGI77W0AUTwR52VTBhTYTOQefm4COnm5o6B0=";
    };
    version = "2024.10";
    defconfig = "radxa-zero-3-rk3566_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${aarch64Pkgs.rkbin}/bin/rk35/rk3568_bl31_v1.44.elf";
    ROCKCHIP_TPL = "${aarch64Pkgs.rkbin}/bin/rk35/rk3566_ddr_1056MHz_v1.21.bin";
    filesToInstall = [ "u-boot.itb" "idbloader.img"];
  };
  radxaZero3 = rockchip ubootRadxaZero3;

  rock64 = rockchip aarch64Pkgs.ubootRock64;
  rockPro64 = rockchip aarch64Pkgs.ubootRockPro64;
  roc-pc-rk3399 = rockchip aarch64Pkgs.ubootROCPCRK3399;
  pinebookPro = rockchip aarch64Pkgs.ubootPinebookPro;
  rock4cPlus = rockchip aarch64Pkgs.ubootRock4CPlus;
}
