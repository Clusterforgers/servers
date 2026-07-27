{ self, inputs, ... }:
let
    system = "x86_64-linux";
in {
    flake.nixosConfigurations.queen = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
        self.nixosModules.queen-configuration

        # Kubernetes Features
        inputs.k3s-cluster.nixosModules.kubernetes-agent

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
