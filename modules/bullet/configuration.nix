{ self, ... }: {
  flake.nixosModules.bullet-configuration = { config, pkgs, ... }: {
    imports = [ self.nixosModules.bullet-hardware ];

    networking.hostName = "bullet";
    system.stateVersion = "25.05";

    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
      fastfetch
    ];

    users.users.root.shell = pkgs.fish;
  };
}
