{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, naersk, ... }:
    utils.lib.eachDefaultSystem
      (system:
        let
          name = "rtiermaker";
          pkgs = import nixpkgs { inherit system; };
          naersk-lib = naersk.lib."${system}";
        in
        rec {
          packages.${name} = naersk-lib.buildPackage {
            pname = "${name}";
            root = ./.;
            copyLibs = true;
            buildInputs = with pkgs; [
              cairo
              gdk-pixbuf
              gobject-introspection
              graphene
              gtk4
              gtksourceview5
              libadwaita
              pango
              pkgconfig
              wrapGAppsHook
            ];
          };

          defaultPackage = packages.${name};
          packages.default = packages.${name};

          apps.${name} = utils.lib.mkApp {
            inherit name;
            drv = packages.${name};
          };
          defaultApp = apps.${name};
          apps.default = apps.${name};

          devShells = {
            default = pkgs.mkShell {
              nativeBuildInputs =
                with pkgs; [
                  rustc
                  cargo
                  cairo
                  gdk-pixbuf
                  gobject-introspection
                  graphene
                  gtk4
                  gtksourceview5
                  libadwaita
                  pango
                  pkgconfig
                  wrapGAppsHook
                ];
            };
          };
        }
      );
}
