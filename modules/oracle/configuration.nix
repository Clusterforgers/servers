{ self, ... }: {
  flake.nixosModules.oracle-configuration = { config, pkgs, ... }: {
    imports = [ self.nixosModules.oracle-hardware ];

    networking.hostName = "oracle";
    system.stateVersion = "25.05";

    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
      fastfetch
    ];

    users.users.root.shell = pkgs.fish;
  };
}
