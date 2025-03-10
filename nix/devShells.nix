# Defines all devShells for the flake
{ system, pkgs, inputs }:
let
  inherit (inputs) fenix;
  rustToolchain = fenix.packages.${system}.fromToolchainFile {
    file = ../rust-toolchain.toml;
    sha256 = "sha256-AJ6LX/Q/Er9kS15bn9iflkUwcgYqRQxiOIL2ToVAXaU";
  };
  rustPlatform = pkgs.makeRustPlatform {
    inherit (rustToolchain) cargo rustc;
  };
in
{
  default = pkgs.mkShell {
    # These programs be available to the dev shell
    buildInputs = (with pkgs; [
      cargo-deny
      nixpkgs-fmt
    ]) ++ pkgs.lib.optional pkgs.stdenv.isDarwin [
      pkgs.libiconv
    ] ++ [
      rustToolchain
      rustPlatform.bindgenHook
      # fenix.packages.${system}.rust-analyzer
    ];

    # Hook the shell to set custom env vars
    shellHook = ''
    '';
  };
}
