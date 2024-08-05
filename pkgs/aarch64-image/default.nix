{ stdenv, fetchurl, zstd }:

stdenv.mkDerivation {
  name = "aarch64-image";
  src = (fetchurl {
    # unfortunally there is no easy way right now to reproduce the same evaluation
    # as hydra, since `pkgs.path` is embedded in the binary
    # To get a new url use:
    # $ curl -s -L -I -o /dev/null -w '%{url_effective}' "https://hydra.nixos.org/job/nixos/release-20.03/nixos.sd_image.aarch64-linux/latest/download/1"
    url = "https://hydra.nixos.org/build/268348742/download/1/nixos-sd-image-24.05.3485.05405724efa1-aarch64-linux.img.zst";
    sha256 = "47cfc148991f5f8127071f611594af4cf02ec976c71c4d42a0988d0b3f18534e";
  }).overrideAttrs
    {
      __structuredAttrs = true;
      unsafeDiscardReferences.out = true;
    };
  preferLocalBuild = true;
  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  # Performance
  dontPatchELF = true;
  dontStrip = true;
  noAuditTmpdir = true;
  dontPatchShebangs = true;

  nativeBuildInputs = [
    zstd
  ];

  installPhase = ''
    zstdcat $src > $out
  '';
}
