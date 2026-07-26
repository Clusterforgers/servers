{ self, ... }: {
  flake.nixosModules.oracle-configuration = { config, pkgs, secrets, ... }: {
    imports = [ self.nixosModules.oracle-hardware ];

    networking.hostName = "oracle";
    system.stateVersion = "25.05";

    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
      fastfetch
    ];

    users.users.root.openssh.authorizedKeys.keys = secrets.sshKeys;
    users.users.root.shell = pkgs.fish;
  };
}
