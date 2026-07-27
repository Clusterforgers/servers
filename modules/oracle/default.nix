{ self, inputs, ... }:
let
    system = "aarch64-linux";
in {
    flake.nixosConfigurations.oracle = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
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
