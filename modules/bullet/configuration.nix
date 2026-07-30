{ self, ... }: {
  flake.nixosModules.bullet-configuration = { config, pkgs, ... }: {
    imports = [ self.nixosModules.bullet-hardware ];

    networking.hostName = "bullet";
    networking.firewall.allowedTCPPorts = [ 80 443 25565 ];
    system.stateVersion = "25.05";

    networking.networkmanager.enable = true;
    services.resolved.enable = true;
    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
      fastfetch
    ];

    users.users.root.shell = pkgs.fish;
  };
}
