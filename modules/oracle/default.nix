{ self, inputs, ... }:
let
    system = "aarch64-linux";
    secretsPath = let p = builtins.getEnv "NIXOS_SECRETS_PATH"; in
        if p != "" then p
        else throw "Set NIXOS_SECRETS_PATH to the path of your local secrets.nix (see README)";
    commonArgs = {
        inherit inputs;
        secrets = import secretsPath;
    };
in {
    flake.nixosConfigurations.oracle = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = commonArgs;
    modules = [
        self.nixosModules.oracle-configuration

        # Kubernetes Features
        inputs.k3s-cluster.nixosModules.kubernetes-server
        inputs.k3s-cluster.nixosModules.kubernetes-deployments

        inputs.home-manager.nixosModules.home-manager
            {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.users.root = {
                    home.stateVersion = "25.05";
                };
            }
        ];
    };
}
