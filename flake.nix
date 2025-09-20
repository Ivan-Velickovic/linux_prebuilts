{
  description = "A flake for building flashable images for seL4 development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }@inputs: inputs.utils.lib.eachSystem [
    "x86_64-linux"
    "aarch64-linux"
  ]
    (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        linux-615 = pkgs.fetchFromGitHub {
          owner = "torvalds";
          repo = "linux";
          rev = "v6.15";
          hash = "sha256-PQjXBWJV+i2O0Xxbg76HqbHyzu7C0RWkvHJ8UywJSCw=";
        };

        linux-616 = pkgs.fetchFromGitHub {
          owner = "torvalds";
          repo = "linux";
          rev = "v6.16";
          hash = "sha256-7Nbq7gyooVwKUpHnOUNUvYPxY9kwCzgw4kGdTiEkKkk=";
        };

        linux-616-x86-64 = (pkgs.callPackage ./linux.nix {}) {
          version = "6.16";
          src = linux-616;
          arch = "x86_64";
          defconfig = "defconfig";
        };

        linux-616-arm64 = (pkgs.pkgsCross.aarch64-multiplatform.callPackage ./linux.nix {}) {
          version = "6.16";
          src = linux-616;
          arch = "arm64";
          defconfig = "defconfig";
        };

        linux-616-riscv64 = (pkgs.pkgsCross.riscv64.callPackage ./linux.nix {}) {
          version = "6.16";
          src = linux-616;
          arch = "riscv";
          defconfig = "defconfig";
        };

        allImages = pkgs.runCommand "all-images" { nativeBuildInputs = with pkgs; [ gnutar gzip ]; }
          ''
            mkdir -p $out

            mkdir -p $out/linux-616-x86-64/
            cp ${linux-616-x86-64}/* $out/linux-616-x86-64/

            mkdir -p $out/linux-616-arm64/
            cp ${linux-616-arm64}/* $out/linux-616-arm64/

            mkdir -p $out/linux-616-riscv64/
            cp ${linux-616-riscv64}/* $out/linux-616-riscv64/

            cd $out
            for f in linux-*; do tar cf - $f | gzip -9 > `basename $f`.tar.gz; done
          ''
        ;
      in
      {
        packages.linux-616-x86-64 = linux-616-x86-64;
        packages.linux-616-arm64 = linux-616-arm64;
        packages.linux-616-riscv64 = linux-616-riscv64;

        packages.default = allImages;
      });
}
