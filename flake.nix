{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    outputs = { self, nixpkgs }: 
    let
        pkgs = nixpkgs.legacyPackages."x86_64-linux"; 

        nodeApp = pkgs.buildNpmPackage {
            pname = "playwright-server";
            version = "0.1.0";
            src = ./.;

            dontNpmBuild = true;
            npmDepsHash = "sha256-6zz3FqrQPGZAFyv2GQUo23UYA0YVLtd3tFB6LY2PxZg=";

            installPhase = ''
                mkdir -p $out
                cp -r . $out/
            '';
        };

        appScript = pkgs.writeShellScriptBin "start-script" ''
            export PLAYWRIGHT_BROWSERS_PATH="${pkgs.playwright-driver.browsers}"

            exec ${pkgs.nodejs}/bin/node ${nodeApp}/index.js "$@"
        '';
    in {
        apps."x86_64-linux".default = {
            type = "app";
            program = "${appScript}/bin/start-script";
            args = [];
        };

        devShells."x86_64-linux".default = pkgs.mkShell {
            packages = [
                pkgs.nodejs
                pkgs.playwright-driver.browsers
            ];

            shellHook = ''
                export NPM_CONFIG_PREFIX="$HOME/.npm"
                export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
            '';
        };
    };
}
