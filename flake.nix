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

        linux615 = pkgs.fetchFromGitHub {
          owner = "torvalds";
          repo = "linux";
          rev = "v6.15";
          hash = "sha256-PQjXBWJV+i2O0Xxbg76HqbHyzu7C0RWkvHJ8UywJSCw=";
        };

        linux616 = pkgs.fetchFromGitHub {
          owner = "torvalds";
          repo = "linux";
          rev = "v6.16";
          hash = "sha256-7Nbq7gyooVwKUpHnOUNUvYPxY9kwCzgw4kGdTiEkKkk=";
        };

        linux616arm64 = (pkgs.pkgsCross.aarch64-multiplatform.callPackage ./linux.nix {}) {
          version = "6.16";
          src = linux616;
          arch = "arm64";
          defconfig = "defconfig";
        };
      in
      {
        packages.default = linux616arm64;
      });
}
