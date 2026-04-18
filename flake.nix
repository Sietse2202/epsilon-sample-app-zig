{
  description = "epsilon-sample-app-zig flake";

  inputs = {
    zls.url = "github:zigtools/zls?ref=0.16.0";
    zig2nix.url = "github:Cloudef/zig2nix";
  };

  outputs = {
    zig2nix,
    zls,
    ...
  }: let
    flake-utils = zig2nix.inputs.flake-utils;
  in (flake-utils.lib.eachDefaultSystem (system: let
    zlsPkg = zls.packages.${system}.default;
    env = zig2nix.outputs.zig-env.${system} {
      zig = zig2nix.outputs.packages.${system}.zig-0_16_0;
    };
  in
    with builtins;
    with env.pkgs.lib; {
      packages.target = genAttrs allTargetTriples (target:
        env.packageForTarget target {
          src = cleanSource ./.;
        });

      apps.test = env.app [] "zig build test -- \"$@\"";
      apps.docs = env.app [] "zig build docs -- \"$@\"";
      apps.deps = env.showExternalDeps;
      apps.zon2json = env.app [env.zon2json] "zon2json \"$@\"";
      apps.zon2json-lock = env.app [env.zon2json-lock] "zon2json-lock \"$@\"";
      apps.zon2nix = env.app [env.zon2nix] "zon2nix \"$@\"";

      devShells.default = env.mkShell {
        nativeBuildInputs = with env.pkgs; [zlsPkg bun python3 nodejs_20 udev.dev libusb1.dev];
        shellHook = ''
          export LD_LIBRARY_PATH="${makeLibraryPath (with env.pkgs; [udev libusb1])}:$LD_LIBRARY_PATH"
          export C_INCLUDE_PATH="${env.pkgs.udev.dev}/include:${env.pkgs.libusb1.dev}/include:$C_INCLUDE_PATH"
          export CPLUS_INCLUDE_PATH="$C_INCLUDE_PATH"
          export npm_config_nodedir="${env.pkgs.nodejs_20}"
        '';
      };
    }));
}
