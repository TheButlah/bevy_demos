{
  description = "NexusSocial/identity repo";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs-raw@{ flake-utils, ... }:
    let
      # All systems we may care about evaluating nixpkgs for
      systems = with flake-utils.lib.system; [ x86_64-linux aarch64-linux aarch64-darwin x86_64-darwin ];
      perSystem = (system: rec {
        inputs = inputs-raw;
        pkgs = import inputs.nixpkgs-unstable {
          inherit system;
          overlays = [
          ];
          config = {
            # allowUnfree = true;
          };
        };
      });
      # This `s` helper variable caches each system we care about in one spot
      inherit (flake-utils.lib.eachSystem systems (system: { s = perSystem system; })) s;
    in
    # System-specific stuff goes in here, by using the flake-utils helper functions
    flake-utils.lib.eachSystem systems
      (system:
        let
          inherit (s.${system}) pkgs inputs;
        in
        {
          devShells = import ./nix/devShells.nix { inherit system pkgs inputs; };
          formatter = pkgs.nixpkgs-fmt;
        }
      );
}
