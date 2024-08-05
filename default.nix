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
    defconfig = "radxa-zero-3-rk3566_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    BL31 = "${aarch64Pkgs.rkbin}/bin/rk35/rk3568_bl31_v1.44.elf";
    ROCKCHIP_TPL = "${aarch64Pkgs.rkbin}/bin/rk35/rk3568_ddr_1056MHz_v1.23.bin";
    filesToInstall = [ "u-boot.itb" "idbloader.img"];
  };
  radxaZero3 = rockchip ubootRadxaZero3;

  rock64 = rockchip aarch64Pkgs.ubootRock64;
  rockPro64 = rockchip aarch64Pkgs.ubootRockPro64;
  roc-pc-rk3399 = rockchip aarch64Pkgs.ubootROCPCRK3399;
  pinebookPro = rockchip aarch64Pkgs.ubootPinebookPro;
  rock4cPlus = rockchip aarch64Pkgs.ubootRock4CPlus;
  cm3588NAS = rockchip aarch64Pkgs.ubootCM3588NAS;
}
